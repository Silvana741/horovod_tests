#!/bin/bash -l


#SBATCH --job-name="Jupyter_job_iris"

#SBATCH --output=Notebooks_logs/IRIS/notebook_%j.log

#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH -c 7 ###dedicate 1/4th of available cores for management
#SBATCH -G 1
#SBATCH --time=04:00:00
#SBATCH -p gpu


    
## other options
#SBATCH --mail-user=silvana.belegu@uni.lu
#SBATCH --mail-type=all
## Move to the directory where the job was submitted
#cd $SLURM_SUBMIT_DIR


print_error_and_exit() { echo "***ERROR*** $*"; exit 1; }
module purge || print_error_and_exit "No 'module' command"
# Python 3.X by default (also on system)



source /work/projects/ulhpc-tutorials/PS10-Horovod/env.sh
micromamba activate parallel_mpi 


python --version
#module avail
#jupyter notebook --ip $(facter ipaddress) --no-browser  &
jupyter lab --ip $(ip addr | egrep '172\.17|21'| grep 'inet ' | awk '{print $2}' | cut -d/ -f1) --no-browser &
pid=$!
sleep 5s
jupyter notebook list
jupyter --paths
jupyter kernelspec list
#echo "Enter this command on your laptop: ssh -p 8022 -NL 8888:$(facter ipaddress):8888 clee@access-iris.uni.lu" > notebook.log
echo "Enter this command on your laptop: ssh -p 8022 -NL 8888:$(ip addr | egrep '172\.17|21'| grep 'inet ' | awk '{print $2}' | cut -d/ -f1):8888 sbelegu@acces-iris.uni.lu" > notebook_iris.log
wait $pid
