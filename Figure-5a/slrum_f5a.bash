#!/bin/bash
## sbatch slrum_f5a.bash
## array_ids%max_number_concurrent
#SBATCH --array=0-100%100
##SBATCH --array=0-1300%100
## %a will be array task id, %A is the job ID
#SBATCH --job-name=GO_term_dist%a
#SBATCH --output=output_bash/f5a_%A_%a.log
#SBATCH --ntasks=1
#SBATCH --mem=2gb
#SBATCH --time=10:00:00
#SBATCH --cpus-per-task=1
#SBATCH --chdir=/home/XX/YY/

XDG_RUNTIME_DIR=""

## S BATCH --array=0-6858%1024

date;hostname;pwd

##source  $HOME/.bashrc

##conda activate /home/xx/.conda/envs/yy

module load anaconda3/2022.05

which python

python fig5_a.py $SLURM_ARRAY_TASK_ID 100

