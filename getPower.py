#! /usr/bin/env python
import csv,sys,os
log = sys.argv[1]
log =os.path.abspath(log)
log_name=(log.rsplit('.')[-2])
file_handler = open(log_name+'_powerstats.csv','a')
with open(log) as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    for row in csv_reader:
        '''
        for i in row:
            print line_count, i
            line_count+=1
        break
        '''
        if line_count  ==1:
            firsttime = float(row[1])
        if line_count != 0 and row[175] !='' :
            power1 = (row[175])
            time =float(row[1])
            rel_time =float(row[1]) - firsttime
            #voltage1 = float(row[188])/1000.0
            #voltage2 = float(row[442])/1000.0
            voltage3 = float(row[169])
            #curr0 = (row[189])
            #curr1 = (row[443])
            curr2 = (row[168])
            #power2 = (row[1001])
            battpercentage = (row[171])
            #file_handler.write('\n{0},{1},{2},{3},{4},{5},{6},{7},{8},{9}'.format(time,voltage1,voltage2,voltage3,curr0,curr1,curr2,battpercentage,power1,power2))
            file_handler.write('\n{0},{1},{2},{3},{4},{5}'.format(time,rel_time,voltage3,curr2,battpercentage,power1))
        elif line_count ==0:
            #file_handler.write('time,battery_info:pack_voltage 188,battery_info:pack_voltage 442,Battery(0):totalVolts 169,battery_info:current 189,battery_info:current 443,Battery(0):current 168,Battery(0):battery 171,Battery(0):watts 175,bat_max_power_info:cur_power 1001')
            file_handler.write('time(s),relative_time(s),voltage(Volts),current(Amps),Battery_Percentage,Power(watts)')
        line_count +=1
    file_handler.close()


#653 1001 bat_max_power_info:cur_power
#71 442 188 battery_info:pack_voltage
#72 443 189 battery_info:current
#175 Battery(0):watts
#168 Battery(0):current
#169 Battery(0):totalVolts
#171 Battery(0):battery%