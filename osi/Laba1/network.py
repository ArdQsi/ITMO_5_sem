import subprocess
import matplotlib.pyplot as plt
import time
import re
from time import sleep

def plot_graph(timestamps, data, name, isList, xLabel, yLabel):
    plt.figure(figsize=(10, 6))
    print(data)
    if not isList:
        for sublist in data:
            plt.plot(timestamps, sublist)
            print(sublist)
    else:
        plt.plot(timestamps, data)

    plt.xlabel(xLabel)
    plt.ylabel(yLabel)
    plt.title(name)
    plt.grid(True)
    plt.savefig(name)

def read_data_from_utility(sp, command, name):
    timestamps = []
    data = []
    prev_bytes = 0.0
    while sp.poll() is None :
        try:
            output = subprocess.check_output(command, shell=True, text=True)
        except Exception as e:
            break
        if(output):
            output = output.split('\n')
            new_output = []
            for row in output:
                if(row != ''):
                    row = re.sub(r'\s+', ' ', row)
                    row = re.sub(r',', '.', row)
                    row = row.split(' ')
                    new_output.append(row)        
            output = new_output  
            print(output[3][1])
            print(output[5][1])
            if prev_bytes == 0.0:
                prev_bytes = float(output[3][1]) + float(output[5][1])
            else:
                bytes = float(output[3][1]) + float(output[5][1])
                timestamps.append(time.time())
                data.append(bytes - prev_bytes)
                prev_bytes = bytes
        sleep(1)    
    plot_graph(timestamps, data, name, True, 'time', 'byte/s')

def network():
    for i in range(1, 12, 1):
        command = f'stress-ng --dccp  {i} --timeout 20'
        print(command)
        sp = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        read_data_from_utility(sp, 'ip -s link show lo', f'dccp-{i}')

    for i in range(1, 100, 5):
        command = f'sudo stress-ng --netlink-task {i} --timeout 20'
        print(command)
        sp = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        read_data_from_utility(sp, 'ip -s link show lo', f'netlink-task-{i}')

network()