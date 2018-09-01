# !/bin/bash

#Write a script that will produce a minute-by-minute CSV that contains an
#aggregate count of the accesses organized by HTTP status code for all log files in a directory
#input: directory containing apache access log files

dir=$1

for filename in $dir/*
do
    aggregateFile=${filename}_aggregation.csv

    #check if aggregateFile exists, if yes, remove it first.
    if [ -f "$aggregateFile" ] 
    then 
       rm ${aggregateFile}; 
    fi

    get_all_relevant_data=$(awk -F \[ '{print $2}' $filename | awk '{print $6" "$1}' | awk -F \: '{print $1":"$2":"$3}' | sort | uniq -c)
    get_all_http_codes=$(printf "$get_all_relevant_data" | awk '{print $2}' | sort | uniq)
   
    for i in $get_all_http_codes
    do
       echo "#$i" >> ${aggregateFile}
       printf "$get_all_relevant_data\n" | awk -v httpcode="$i" '$2==httpcode {print $3","$1}' >> ${aggregateFile}
    done
done
