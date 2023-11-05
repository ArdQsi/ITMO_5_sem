import subprocess
import matplotlib.pyplot as plt
import time
import re
from time import sleep

def read_system_data(sb, command, col_index, name ,thread_num):
    data = [[] for _ in range(thread_num)]
    timestamps = []
    while sb.poll() is None :
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
            output = sorted(output, key=lambda x: x[1])
            output = [x for x in output if (x[8]) != 'S']
            print(output)
            if(len(output) == thread_num):
                print(output)
                timestamps.append(time.time())
                for i in range(thread_num):
                    data[i].append(float(output[i][col_index]))
        sleep(2)            

    plot_graph(timestamps, data, name, False, 'time', '%MEM')
    


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
    plt.title('System Performance')
    plt.grid(True)
    plt.savefig(name)
    return 
    

def memory():
    for i in range(1, 9):
        command = f'stress-ng --memthrash {i} --timeout 10'
        print(command)
        sp = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        read_system_data(sp, 'top -b -n 1 | grep -m 100 stress-ng',10, f'memthrash-{i}', 1) #constant mem usage
    for i in range(1, 10, 3):
        for j in range(8, 4096, 800):
            command = f'stress-ng --memfd  {i} --memfd-fds {j} --timeout 10'
            print(command)
            sp = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            read_system_data(sp, 'top -b -n 1 | grep -m 123 stress-ng',10, f'memfd-workers-{i}-fds-{j}', i)
memory()