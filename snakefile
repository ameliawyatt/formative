import glob
import re

# # Get the list of pid values from the filenames in data/original/accel/
accel_files = glob.glob("data/original/accel/accel-*.txt")
ACC_PID = [int(re.search(r"accel-(\d+).txt", f).group(1)) for f in accel_files]

# To keep things a bit simpler, we can hard-code a small list of participant IDs instead of reading in every participant ID from the filenames as above
# This will mean that if any of the accelerometer data files change or some or added or removed then snakemake won't know to re-run the pipeline
ACC_PID = [31128, 31129, 31131, 31132, 31133, 31134, 31137]

rule setup:
    "setup required directories"
    shell:
        """
        mkdir -p logs
        mkdir -p data/derived
        mkdir -p data/original
        mkdir -p results
        """

rule all:
    input:
        "data/derived/body_measurements.csv",
        "data/derived/sample.csv",
        "logs/bmx_check.log",
        "logs/accel_check.log",
        "logs/accel_fix.log",
        "logs/sample_index_list.log",
        "logs/5-generate-sample.log",
        "logs/6-demo_data_prep.log"


## Step 1: Checking the data files and making sure they are in a standard file format
# Check the body measures data:
rule check_bm_data:
    input:
        "data/original/BMX_D.csv"
    output:
        "logs/bmx_check.log"
    shell:
        """
        bash code/bmx_check.sh > logs/bmx_check.log
        """

# Check the accelerometer data:
rule check_accel_data:
    input:
        "logs/bmx_check.log",
        expand("data/original/accel/accel-{pid}.txt", pid=ACC_PID)
    output:
        "logs/accel_check.log"
    shell:
        """
        bash code/accel_check.sh > logs/accel_check.log
        """

# Fix the accelerometer data:
rule fix_accel_data:
    input:
        "logs/accel_check.log",
        expand("data/original/accel/accel-{pid}.txt", pid=ACC_PID)
    output:
        expand("data/derived/accel/accel-{pid}.txt", pid=ACC_PID),
        "logs/accel_fix.log"
    shell:
        """
        bash code/accel_fix.sh > logs/accel_fix.log
        """

## Step 2: Generating a sample file

# Our sample file contains an binary variable that indicates whether a participant is in our sample versus not in our sample.
# A participant is included in our sample if they have accelerometer data and a BMI value.
# First we create a list of participant IDs for those with an accelerometer file:
rule make_pid_list:
    input:
        "logs/accel_fix.log",
        expand("data/derived/accel/accel-{pid}.txt", pid=ACC_PID)
    output:
        "data/derived/accelIndexList.txt",
        "logs/sample_index_list.log"
    shell:
        """
        bash code/sample_index_list.sh > logs/sample_index_list.log
        """
# Then we derive a sample file:
rule make_sample:
    input:
        "logs/bmx_check.log",
        "data/derived/accelIndexList.txt",
        "data/original/BMX_D.csv"
    output:
        "data/derived/sample.csv",
        "logs/5-generate-sample.log"
    shell:
        """
        Rscript code/5-generate-sample.R > logs/5-generate-sample.log
        """


# Preparing and merging the demographics data

# Preparing and merging demographics variables into the body measurements data. 
# It also merges in the sample file prepared previously and saves the combined body_measurements.csv file to the derived data directory.
# Variable names are standardised to lower snake case.
rule merge_data:
    input:
        "data/original/BMX_D.csv",
        "data/original/DEMO_D.XPT",
        "data/derived/sample.csv"
    output:
        "data/derived/body_measurements.csv",
        "logs/6-demo_data_prep.log"
    #conda: "ahds_formative"
    shell:
        """
        Rscript code/6-demo_data_prep.R > logs/6-demo_data_prep.log
        """