import subprocess   
from matplotlib import pyplot as plt
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
            output = [x for x in output if float(x[col_index]) != 0.0]
            print(output)
            if(len(output) == thread_num):
                timestamps.append(time.time())
                for i in range(thread_num):
                    data[i].append(float(output[i][col_index]))
        sleep(2)            

    output = sb.communicate()[1]
    plot_graph(timestamps, data, name, False, 'time', '%cpu')
    return output

def plot_graph(timestamps, data, name, isList, xLabel, yLabel):
    plt.figure(figsize=(10, 6))

    if not isList:
        for sublist in data:
            plt.plot(timestamps, sublist)
    else:
        plt.plot(timestamps, data)
    
    plt.xlabel(xLabel)
    plt.ylabel(yLabel)
    plt.title(name)
    plt.grid(True) 
    plt.savefig(name)
    return 
    

def cpu():
    stressors = []
    bogops = []
    bogopsps = []
    for i in range(1, 9):
        command = f'stress-ng --cpu {i} --cpu-method bitops --timeout 10 --metrics-brief'
        print(command)
        sp = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        system_data = read_system_data(sp, 'top -b -n 1 | grep -m 100 stress-ng', 9, f'cpu-bitops-{i}', i)
        system_data = system_data.split('\n')
        system_data = system_data[5]
        system_data = re.sub(r'\s+', ' ', system_data)
        system_data = system_data.split(' ')
        bogops.append(float(system_data[4]))
        bogopsps.append(float(system_data[8]))
        stressors.append(i)
    plot_graph(stressors, bogops, 'bogops bitops', True, 'stressors', 'bogo ops')
    plot_graph(stressors, bogopsps, 'bogopss bitops', True, 'stressors', 'bogo ops/s')

    stressors.clear()
    bogops.clear()
    bogopsps.clear()
    for i in range(1, 9):
        command = f'stress-ng --cpu {i} --cpu-method int8 --timeout 10 --metrics-brief'
        print(command)
        sp = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        system_data = read_system_data(sp, 'top -b -n 1 | grep -m 100 stress-ng', 9, f'cpu-int8-{i}', i)
        system_data = system_data.split('\n')
        system_data = system_data[5]
        system_data = re.sub(r'\s+', ' ', system_data)
        system_data = system_data.split(' ')
        bogops.append(float(system_data[4]))
        bogopsps.append(float(system_data[8]))
        stressors.append(i)
    plot_graph(stressors, bogops, 'bogops int8', True, 'stressors', 'bogo ops')
    plot_graph(stressors, bogopsps, 'bogopss int8', True, 'stressors', 'bogo ops/s')

cpu()
