import subprocess
import matplotlib.pyplot as plt
import time
import re
from time import sleep

def read_system_data(sb, command, col_index, name ,thread_num):
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
            
            timestamps = []
            dataread = []
            datawrite = []
            for i in range(len(output)):
                timestamps.append(time.time())
                dataread.append(float(output[i][4]))
                datawrite.append(float(output[i][6]))
        plot_graph(timestamps, dataread, name + "read", True, 'time', 'disk read k/s')
        plot_graph(timestamps, datawrite, name + "write", True, 'time', 'disk write k/s')
        sleep(10)            
        print(dataread)
        print('hello')
        print(datawrite)

def plot_graph(timestamps, data, name, isList, xLabel, yLabel):
    plt.figure(figsize=(10, 6))

    if not isList:
        for sublist in data:
            plt.plot(timestamps, sublist)
    else:
        plt.plot(timestamps, data)
    

    plt.xlabel(xLabel)
    plt.ylabel(yLabel)
    plt.title('System Performance')
    plt.grid(True)
    plt.savefig(name)
    

def io_metrics():
    for i in range(1, 100, 5):
        command = f'stress-ng --iomix {i} --timeout 10'
        print(command)
        sp = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        read_system_data(sp, 'sudo iotop -b -k -P -n 1 | grep -m 123 stress-ng-iomix',6, f'iomix-{i}', i)

io_metrics()