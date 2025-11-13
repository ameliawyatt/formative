import glob
import re

accel_files = glob.glob("data/original/accel/accel-*.txt")
ACC_PID = [int(re.search(r"accel-(\d+).txt", f).group(1)) for f in accel_files]


rule all:
    input: 
        "logs/bmx_check.log",
        "logs/accel_check.log",
        "logs/accel_fix.log",
        "logs/sample_index_list.log",
        "data/derived/accelIndexList.txt",
        "data/derived/indexList_in.txt",
        "logs/writeSample.log",
        "logs/demo_data_prep.log"


rule bmx_check:
    input:
        "data/original/BMX_D.csv"
    output:
        "logs/bmx_check.log"
    shell:
        """
        bash code/bmx_check.sh > logs/bmx_check.log
        """

rule accel_check:
    input:
        "logs/bmx_check.log",
        expand("data/original/accel/accel{pid}.txt", pid=ACC_PID)
    output:
        "logs/accel_check.log"
    shell:
        """
        bash code/accel_check.sh > logs/accel_check.log
        """

rule accel_fix:
    input:
        "logs/accel_check.log",
        expand("data/original/accel/accel{pid}.txt", pid=ACC_PID)
    output:
        "logs/accel_fix.log",
        expand("data/derived/accel/accel{pid}.txt", pid=ACC_PID)
    shell:
        """
        bash code/accel_fix.sh > logs/accel_fix.log
        """
rule sample_index_list:
    input: 
        "logs/accel_fix.log",
        expand("data/derived/accel/accel{pid}.txt", pid=ACC_PID)
    output: 
        "logs/sample_index_list.log",
        "data/derived/accelIndexList.txt",
        "data/derived/indexList_in.txt"
    shell:
        """
        bash code/sample_index_list.sh > logs/sample_index_list.log
        """

rule write_sample:
    input:
        "data/original/BMX_D.csv",
        "data/derived/indexList_in.txt"
    output:
        "data/derived/sample.csv",
        "logs/writeSample.log"
    shell:
        """
        Rscript code/writeSample.R > logs/writeSample.log
        """

rule demo_data_prep:
    input:
        "data/original/DEMO_D.XPT",
        "data/original/BMX_D.csv",
        "data/derived/sample.csv"
    output:
        "data/derived/body_measurements.csv",
        "logs/demo_data_prep.log"

    shell:
        """
        Rscript code/demo_data_prep.R > logs/demo_data_prep.log
        """
