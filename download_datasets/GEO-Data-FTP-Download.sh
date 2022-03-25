#!/bin/sh
#$ -S /bin/sh
#$ -pe smp 1
#$ -cwd
#$ -V
#### Jobdescription at qstat
#$ -N GEO-FTP-Download

#### Error Outputfile
#$ -e /home/marteau/myScratch/tmp/LOGS/$JOB_NAME-$JOB_ID.err
#$ -o /home/marteau/myScratch/tmp/LOGS/$JOB_NAME-$JOB_ID.log

#### Resubmit
#$ -r y

# <Your bash code here>
path=$1
meta=$2

function download_GSE_via_FTP {
    mkdir -p $path/$doi/$GSE
    cd $path/$doi/$GSE
    wget -r -np -nd -nc -R "index.html*" ftp://ftp.ncbi.nlm.nih.gov/geo/series/$GSE2/$GSE/ #-nd to remove sub directories
    if [ "$?" != 0 ]
    then
      echo $GSE Download Failed > /dev/stderr
    fi
}

while IFS="," read -r doi GSE
do
  GSE2=$(echo $GSE | sed 's/.\{3\}$/nnn/')
  download_GSE_via_FTP $doi $GSE

done < $meta