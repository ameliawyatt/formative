#!/bin/bash

# code written to run from the data directory
DATADIR='../data'

#cut -f2,12 -d',' BMX_D.csv | head
#cut -f2,12 -d',' BMX_D.csv | grep "NA" -v | head
#cut -f2,12 -d',' BMX_D.csv | grep "NA" -v | cut -f1 -d',' | head
#BMX_D.csv | grep -i -v "NA" | grep -v "SEQN" | cut -f1 -d',' > ../derived/BMI_indexes.csv

## TODO
#Re-write script to create indexes file

# accel list
#for txt in *.txt;  do accelCount=`wc -l $txt`;  if [[ $accelCount == 10082* ]]; then   head -n1 $txt | grep -o '[0-9]\+'; fi;  done > ../../derived/accelIndexes.txt
for txt in ${DATADIR}/derived/accel/*.txt; do echo $txt | grep -o '[0-9]\+'; done > ${DATADIR}/derived/accelIndexList.txt

# common index list
grep -F -x -f  ${DATADIR}/derived/BMI_indexes_in.csv ${DATADIR}/derived/accelIndexList.txt > ${DATADIR}/derived/indexList_in.txt