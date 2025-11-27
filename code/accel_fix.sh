#!/bin/bash

### Accel Data preparation
# code written to run from the data directory
DATADIR='data'

## Column missingness fix
# make a copy of the accel directroy into the derived directory for editing
#### NOTE: this creates the data/derived directory
mkdir -p ${DATADIR}/derived
cp -r ${DATADIR}/original/accel ${DATADIR}/derived/

## Remove all the lines with 3 columns with NA values
sed -i '/NA\tNA\tNA/d' ${DATADIR}/derived/accel/accel-*.txt

# repeat the same column checking command to check the edit worked
echo "Lines that don't have 8 columns:"
cat ${DATADIR}/derived/accel/accel-*.txt | grep -v '<' | awk -F'\t' '(NF!=8){print $0}' | sort -u

## Reformat files by removing first line
for txt in ${DATADIR}/derived/accel/accel-*.txt; do
  sed -i '1d' $txt
done
# check the change happened as expected - should have column names in first row
echo "check a file to see if column names are in first row:"
accelSample=`ls ${DATADIR}/derived/accel | head -n1`
head ${DATADIR}/derived/accel/$accelSample