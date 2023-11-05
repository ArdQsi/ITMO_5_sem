import subprocess
import matplotlib.pyplot as plt
import re

def plot_graph(timestamps, data, name, xLabel, yLabel):
    plt.figure(figsize=(10, 6))
    plt.plot(timestamps, data)
    plt.xlabel(xLabel)
    plt.ylabel(yLabel)
    plt.title(name)
    plt.grid(True)
    plt.savefig(name)
    return 

def scheduler():
    timestamps = []
    readdata = []
    writedata = []

    for i in range(-20, 20, 5):
        command = f'stress-ng --hdd 10 --sched-prio {i} --timeout 15'
        print(command)
        sp = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        write_speed = 0
        read_speed = 0
        output = subprocess.check_output('iostat 1 15 | grep sda', shell=True, text=True)
        output = output.split('\n')
        for str in output:
            str = re.sub(r'\s+', ' ', str)
            str = re.sub(r',', '.', str)
            str = str.split(' ')
            if(str != ['']):
                write_speed += float(str[3])
                read_speed += float(str[2])
        timestamps.append(i)
        readdata.append(read_speed / 15)
        writedata.append(write_speed / 15)
        print(f'sched prio {i}:')    
        print(write_speed / 15)
        print(read_speed / 15)
    plot_graph(timestamps, readdata, f'read-prio', 'prio', 'kB_read/s')
    plot_graph(timestamps, writedata, f'write-prio', 'prio', 'kB_write/s')
    
    timestamps = []
    readdata = []
    writedata = []

    for i in range(1, 100000, 25000):
        command = f'stress-ng --hdd 10 --sched-period {i} --timeout 15'
        print(command)
        sp = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        write_speed = 0
        read_speed = 0

        output = subprocess.check_output('iostat 1 15 | grep sda', shell=True, text=True)
        output = output.split('\n')
        for str in output:
            str = re.sub(r'\s+', ' ', str)
            str = re.sub(r',', '.', str)
            str = str.split(' ')
            if(str != ['']):
                write_speed += float(str[3])
                read_speed += float(str[2])
        timestamps.append(i)
        readdata.append(read_speed / 15)
        writedata.append(write_speed / 15)
        print(f'sched period {i}:')    
        print(write_speed / 15)
        print(read_speed / 15)
    plot_graph(timestamps, readdata, f'read-period', 'period', 'kB_read/s')
    plot_graph(timestamps, writedata, f'write-period', 'period', 'kB_write/s')


scheduler()