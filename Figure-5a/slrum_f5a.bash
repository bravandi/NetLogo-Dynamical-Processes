#!/bin/bash
## sbatch slrum_f5a.bash
## array_ids%max_number_concurrent
#SBATCH --array=0-400%5
## %a will be array task id, %A is the job ID
#SBATCH --job-name=GO_term_dist%a
#SBATCH --output=output_bash/f5a_%A_%a.log
#SBATCH --partition=netsi_standard
#SBATCH --ntasks=1
#SBATCH --mem=2gb
#SBATCH --time=10:00:00
#SBATCH --cpus-per-task=1
#SBATCH --chdir=/work/radlab/Ayan/netlogo/NetLogo-Dynamical-Processes/Figure-5a/

XDG_RUNTIME_DIR=""

date;hostname;pwd

module load anaconda3/2022.05

which python

python fig5_a.py $SLURM_ARRAY_TASK_ID 4