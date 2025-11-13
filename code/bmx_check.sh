#!/bin/bash

## BMX data exploration
#code written to be run from the code directory onto the data directory
DATADIR='data'
# Check top of the csv
head ${DATADIR}/original/BMX_D.csv
# row count
wc -l ${DATADIR}/original/BMX_D.csv

# check number of columns in first 10 rows - there are 28 in each row
awk -F, '{print NF}' ${DATADIR}/original/BMX_D.csv | head
# check all rows have 28 fields by printing the ones that don't - no output so no further action
# this line doesn't work??
#awk -F, '{print NF}' ${DATADIR}/original/BMX_D.csv | grep -v 28


