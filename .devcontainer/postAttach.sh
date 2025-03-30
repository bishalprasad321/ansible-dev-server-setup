#!/bin/sh
# This script is executed after the devcontainer is created and attached to the workspace.
# It is used to set up the environment and install any necessary dependencies.
# It is also used to run any necessary commands to prepare the environment for development.
# This script is executed in the devcontainer environment.

# script directory
script_dir=$(dirname "$(readlink -f "$0")")
echo "current directory : $script_dir"
echo "ansible: $(ansible --version)"
echo "terraform: $(terraform --version)"
echo "aws: $(aws --version)"
echo "gossamer3: $(gossamer3 --version)"
