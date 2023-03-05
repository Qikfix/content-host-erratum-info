#!/bin/bash

# 

REPORT="/var/log/erratum_report.csv"
echo "content_host,errata_id,errata_type,nvrea" > $REPORT

erratum_info=$(hammer --csv --no-headers task list --search 'action ~ Remote action: Run yum updateinfo list installed and result = success' --fields id,action)
echo "$erratum_info" | while read b
do
  id=$(echo $b | cut -d, -f1)
  srvname=$(echo $b | awk '{print $NF}')
  erratum=$(hammer task progress --id $id 2>/dev/null | grep ^RH | tr -s ' ' ',')

  echo "$erratum" | while read line
  do
    echo "$srvname,$line" >> $REPORT
  done
done

echo "File $REPORT created!"
