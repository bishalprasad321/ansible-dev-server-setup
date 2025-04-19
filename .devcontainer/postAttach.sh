#!/bin/sh
# This script is executed after the devcontainer is created and attached to the workspace.
# It is used to set up the environment and install any necessary dependencies.
# It is also used to run any necessary commands to prepare the environment for development.
# This script is executed in the devcontainer environment.

# script directory
script_dir=$(dirname "$(readlink -f "$0")")
# verifying the versions of all the installed tools in the devcontainer
echo "current directory : $script_dir"
echo "ansible: $(ansible --version)"
echo "terraform: $(terraform --version)"
echo "aws: $(aws --version)"
echo "gossamer3: $(gossamer3 --version)"

chmod a+x ${script_dir}/scripts/bld
# Make scripts callable and run bld
ln -nsf ${script_dir}/scripts/bld /usr/local/bin

parent_dir=$(dirname "$script_dir")
cd $parent_dir
bld all

gpg --batch --generate-key <<EOF
Key-Type: 1
Key-Length: 2048
Subkey-Type: 1
Subkey-Length: 2048
Name-Real: Dev Container
Name-Email: devcontainer@example.com
Expire-Date: 0
%no-ask-passphrase
%no-protection
EOF

pass init devcontainer@example.com