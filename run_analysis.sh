#!/bin/bash

#SBATCH --job-name=formative1
#SBATCH --partition=teach_cpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=0:20:00
#SBATCH --mem=100M
#SBATCH --account=SSCM037184
#SBATCH --output ./slurm_logs/%j.out

cd "${SLURM_SUBMIT_DIR}"


#### Do I need these??
echo 'Setting up environment'
source ~/initConda.sh
# conda env create -f r-formativeEnv.yml ### don't need this if you have already created it in bp1
conda activate r-formativeEnv



mkdir -p slurm_logs/
mkdir -p results
mkdir -p logs/

echo 'Starting analysis'
echo 'Checking body measurements data'
bash code/bmx_check.sh > logs/bmx_check.log

echo 'Checking accelerometer data'
bash code/accel_check.sh > logs/accel_check.log

echo 'Fix accelerometer data'
bash code/accel_fix.sh > logs/accel_fix.log

echo 'Making PID list'
bash code/sample_index_list.sh > logs/sample_index_list.log

echo 'Making sample file'
Rscript code/5-generate-sample.R > logs/5-generate-sample.log

echo 'Merging demographics data'
Rscript code/6-demo_data_prep.R > logs/6-demo_data_prep.log

echo 'Analysis complete'


