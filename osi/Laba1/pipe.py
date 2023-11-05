import subprocess   
from matplotlib import pyplot as plt
import time
import re
from time import sleep  

def read_system_data_for_data_size(sb, command, col_index, name, thread_num):
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
            # print(output)      
            output = sorted(output, key=lambda x: x[1])
            output = [x for x in output if float(x[col_index]) != 0.0]
            print(output)
            if(len(output) == thread_num):
                # print(output)
                timestamps.append(time.time())
                for i in range(thread_num):
                    data[i].append(float(output[i][col_index]))
        sleep(2)            

    output = sb.communicate()[1]
    # print(data)
    plot_graph(timestamps, data, name, False, 'time', '%cpu')
    return output


def plot_graph(timestamps, data, name, isList, xLabel, yLabel):
    plt.figure(figsize=(10, 6))
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
    

def pipe():
    stressors = []
    bogops = []
    for i in range(8, 4096, 500):
        command = f'stress-ng --pipe 1 --pipe-data-size {i} --timeout 10 --metrics'
        print(command)
        sp = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        output = read_system_data_for_data_size(sp, 'top -b -n 1 | grep stress-ng', 9, f'pipe-data-size-{i}', 2)
        # bogops
        output = output.split('\n')
        output = output[5]   
        output = re.sub(r'\s+', ' ', output)
        output = output.split(' ')
        bogops.append(float(output[4]))
        stressors.append(i)

    print(bogops)
    plot_graph(stressors, bogops, 'bogops pipe-data-size', True, 'pipe-data-size', 'bogo ops')

    c_sw = []
    for i in range(1, 100, 20):
        command = f'sudo perf stat -e context-switches stress-ng --sigpipe {i} --timeout 10'
        print(command)
        sp = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

        output = sp.communicate()[1]
        print(output)

        output = output.split('\n')
        print(output)

        c_s_l = output[6]
        c_s_l = re.sub(r'\s+', ' ', c_s_l)
        c_s_l = re.sub(r',', '.', c_s_l)
        c_s_l = c_s_l.split(' ')
        print(c_s_l)
        j = 1
        switch_num = 0
        while(c_s_l[j].isnumeric()): 
            switch_num = switch_num*1000 + float(c_s_l[j])
            j+=1
        c_sw.append(switch_num)
    plot_graph([i for i in range(1, 100, 20)], c_sw, f'sigpipe', True, 'stressors', 'switch')

pipe()

   