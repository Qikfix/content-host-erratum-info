# content-host-erratum-info


In order to start, let's cleanup all the tasks related to `yum updateinfo list installed`
```
# foreman-rake foreman_tasks:cleanup:run TASK_SEARCH='action ~ Remote action: Run yum updateinfo list installed and result = success' AFTER=0s --trace
```

In a sequence, you can create a new Job that will execute the command below in all of your Content Hosts. Basically, it will be:

* Satellite webUI - Monitor - Jobs
* Click on `Run Job` button, top right corner
* Create the filter that you need in `Search Query` field, click on `refresh` icon to refresh the information
* Add the text `yum updateinfo list installed` in the `command` text field
* Click on Submit


After that, you can save the script with the command
```
# wget https://raw.githubusercontent.com/waldirio/content-host-erratum-info/main/erratum_info.sh
# chmod +x erratum_info.sh
```

Once your job is finished, you can safely execute the script above, and the output will be saved in `/var/log/erratum_report.csv` in `CSV` format.

```
# ./erratum_info.sh 
File /var/log/erratum_report.csv created!

# head -n5 /var/log/erratum_report.csv 
content_host,errata_id,errata_type,nvrea
waldirio-node03-sat612.domain.local,RHEA-2016:2503,enhancement,GeoIP-1.5.0-11.el7.x86_64
waldirio-node03-sat612.domain.local,RHBA-2018:3230,bugfix,GeoIP-1.5.0-13.el7.x86_64
waldirio-node03-sat612.domain.local,RHBA-2014:0726,bugfix,NetworkManager-1:0.9.9.1-22.git20140326.4dba720.el7_0.x86_64
waldirio-node03-sat612.domain.local,RHBA-2014:0765,bugfix,NetworkManager-1:0.9.9.1-23.git20140326.4dba720.el7_0.x86_64
```

After that, you can import the `CSV` file in your spreadsheet and work with your data.


## Details

Here, we can see some additional information.

Let's check this scenario

node02 with 1377 erratum
```
[root@waldirio-node02-sat612 ~]# yum updateinfo list installed | grep ^RH | wc -l
1377
```
node03 with 2306 erratum
```
[root@waldirio-node03-sat612 ~]# yum updateinfo list installed | grep ^RH | wc -l
2306
```
Now, summarizing both, we can see
```
# echo 1377+2308 | bc
3685
```

After running the remote job and executing the script on Satellite server, we have the output below:
```
# ./erratum_info.sh 
File /var/log/erratum_report.csv created!

# wc -l /var/log/erratum_report.csv 
3684 /var/log/erratum_report.csv
```

Note. There is a difference of 1, it's because of the header.

Note2. To check all the content hosts were the job failed, you can proceed with the below command
```
# hammer --csv task list --search 'action ~ Remote action: Run yum updateinfo list installed and result != success'
```


I hope you enjoy it.
Waldirio