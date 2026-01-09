#!/bin/bash
#SBATCH --account=lkeeponlearning   
#SBATCH --cluster=wice                 # H100 GPUs are on the wICE cluster
#SBATCH --partition=gpu_h100           # The specific H100 partition
#SBATCH --nodes=1                      # All 4 GPUs are on a single node
#SBATCH --gpus-per-node=4              # Request 4 H100 GPUs
#SBATCH --cpus-per-gpu=16              # Request max CPUs (16) per GPU to ensure full node usage
#SBATCH --mem=0                        # Request all available memory on the node (optional but recommended for full node jobs)
#SBATCH --time=16:00:00                
#SBATCH --job-name=nanochat_run_english
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err


# 2. Define Variables
# Adjust these paths to match your actual folder structure
SIF_IMAGE="$VSC_SCRATCH/apptainers/nanochat_V2.sif"
# DATA_SOURCE="$VSC_DATA/nanochat/dataset"
# DATA_DEST="$VSC_SCRATCH/nanochat_data_$SLURM_JOB_ID" 

echo "Starting job on node $SLURMD_NODENAME"
echo "GPUs allocated: $SLURM_GPUS_ON_NODE"

# 4. Run Apptainer
# --nv: Enable NVIDIA GPU support inside container
# --bind: Explicitly map VSC storage locations. 
# We bind the scratch destination to a fixed path inside if needed, or just keep it same.
echo "Running Apptainer..."

apptainer run --nv --bind $VSC_SCRATCH/workspacePython/nanochat:/opt/nanochat --bind $VSC_SCRATCH --env NANOCHAT_BASE_DIR="$VSC_SCRATCH/data/fineweb-english/" "$SIF_IMAGE" bash /opt/nanochat/run_560M.sh

# 5. Cleanup (Optional but polite)
# echo "Cleaning up scratch..."
# rm -rf "$DATA_DEST"

echo "Job finished."