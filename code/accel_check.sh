#!/bin/bash

### Data exploration
# code written to run from the directory
DATADIR='data'
## accel exploration
# number of txt files
txtCount=`ls ${DATADIR}/original/accel | wc -l`
echo "Number of accelerometer files: $txtCount" 
# display the first 10 file names
# naming convention: accel-XXXXX.txt
ls ${DATADIR}/original/accel | head
#check first file
accelSample=`ls ${DATADIR}/original/accel | head -n1`
head ${DATADIR}/original/accel/$accelSample
wc -l ${DATADIR}/original/accel/$accelSample

# check all files have the same first line
# all 7455 files have the same header line
for txt in ${DATADIR}/original/accel/*.txt; do tail -n +2 $txt | head -n 1; done | uniq -c

# check all rows have the expected amount of columns
# check that all lines have 8 columns - there are 3 
echo "Number of columns found in the accelerometer files, different from 8:"
cat ${DATADIR}/original/accel/accel-*.txt | grep -v '<' | awk -F'\t' '{print NF}' | grep -v 8 | sort -u

# print all lines that don't have 8 columns - use this to identify problem files
echo "Lines that don't have 8 columns:"
cat ${DATADIR}/original/accel/accel-*.txt | grep -v '<' | awk -F'\t' '(NF!=8){print $0}' | sort -u

# see which files the NA lines exist in - will need to remove these
echo "Files containing NA lines:"
grep -H -P "NA\tNA\tNA" ${DATADIR}/original/accel/accel-*.txt | sort -u

### TODO
#Add check to check first line number matches file name so it can be removed