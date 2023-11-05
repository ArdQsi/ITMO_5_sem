import subprocess   
from matplotlib import pyplot as plt
import re 

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
    

def cache():
    for i in range(1, 10, 3):
        l1cache_sets = []
        bogops = []
        for j in range(1, 6000, 800):
            command = f'stress-ng --cache {i} --l1cache-sets {j} --timeout 10 --metrics-brief'
            print(command)
            sp = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            system_data = sp.communicate()[1]
            system_data = system_data.split('\n')
            system_data = system_data[5]
            system_data = re.sub(r'\s+', ' ', system_data)
            system_data = system_data.split(' ')
            bogops.append(float(system_data[4]))
            l1cache_sets.append(j)
        plot_graph(l1cache_sets, bogops, f'bogops-cache-sets{i}', True, 'l1cache-sets', 'bogo ops')

    for i in range(1, 10, 3):
        l1cache_size  = []
        bogops = []
        for j in range(1, 6000, 800):
            command = f'stress-ng --cache {i} --l1cache-size {j} --timeout 10 --metrics-brief'
            print(command)
            sp = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            system_data = sp.communicate()[1]
            system_data = system_data.split('\n')
            system_data = system_data[5]
            system_data = re.sub(r'\s+', ' ', system_data)
            system_data = system_data.split(' ')
            bogops.append(float(system_data[4]))
            l1cache_size.append(j)
        plot_graph(l1cache_size, bogops, f'bogops-cache-size{i}', True, 'l1cache-size', 'bogo ops')

cache()
