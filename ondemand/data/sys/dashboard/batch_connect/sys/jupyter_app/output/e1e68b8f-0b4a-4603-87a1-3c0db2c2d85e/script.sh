#!/bin/bash -l

# Set working directory to home directory
cd "${HOME}"

#
# Start Jupyter Notebook Server
#

# Restore the module environment to avoid conflicts
# module restore
module purge

# Load the require modules
module load python/3.6.2 anaconda5/5.0.0-3.6

# Launch the Jupyter Notebook Server
jupyter notebook --config="${CONFIG_FILE}" 
