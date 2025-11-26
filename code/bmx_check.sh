#!/bin/bash
echo "in script"
## BMX data exploration
#code written to be run from the code directory onto the data directory
DATADIR='data'
# Check top of the csv
echo "check top of csv"
head ${DATADIR}/original/BMX_D.csv
# row count
echo "row count"
wc -l ${DATADIR}/original/BMX_D.csv

# check number of columns in first 10 rows - there are 28 in each row
echo "check number of columns in the first 10 rows"
awk -F, '{print NF}' ${DATADIR}/original/BMX_D.csv | head
# check all rows have 28 fields by printing the ones that don't - no output so no further action
echo "check all rows have 28 fields (expect no output)"
awk -F, '{print NF}' ${DATADIR}/original/BMX_D.csv | grep -v "28" | wc -l 
#awk -F, '{print NF}' ${DATADIR}/original/BMX_D.csv | grep -v 28


