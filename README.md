# ansible-dev-server-setup -- using docker & vscode
### This guide is for setting up / configuring vscode for ansible development in devcontainer using docker-desktop (non-native).

To set up yourself for Ansible Development (windows only):
- First ensure WSL (windows subsytem for linux) feature is enabled in your desktop. <br>
NOTE: Your system will need a restart after enabling WSL for the first time.
- Second ensure docker is started in your machine, follow [this link](https://docs.docker.com/desktop/setup/install/windows-install/) to get docker-desktop for windows.
- Assuming you already have Visual Studio Code, you have to download `Dev Containers` extension from extensions marketplace of vscode. <br>
NOTE: Ensure the extension provider is trusted from microsoft.

Having completed the initial step, you now have to get started with the configuration to enable ansible development.
1. Create a folder for your ansible development. (for e.g. ansible-dev)
2. Create a `Dockerfile` inside a subfolder called `.devcontainer`. The contents for the dockerfile would be as below :
```Dockerfile
# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /root

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    git \
    unzip \
    wget \
    jq \
    make \
    python3 \
    python3-pip \
    ansible \
    findutils \
    tar \
    xz-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN export TERRAFORM_VERSION=$(curl --silent "https://checkpoint-api.hashicorp.com/v1/check/terraform" | jq --raw-output ".current_version") \
    && curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o /tmp/terraform.zip \
    && unzip -o /tmp/terraform.zip -d /usr/local/bin \
    && rm /tmp/terraform.zip

# Install AWS CLI
RUN wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
    && unzip awscli-exe-linux-x86_64.zip \
    && ./aws/install

# Install Ansible, Ansible Runner, and Ansible Lint
RUN python3 -m pip install --upgrade pip \
    && pip3 install --ignore-installed pyYAML \
    && pip3 install ansible ansible_runner ansible-lint psycopg2-binary

# Set GPG environment variable
ENV GPG_TTY=$(tty)

CMD [ "bash" ]
```
3. Create a `devcontainer.json` file inside the same subfolder as your Dockerfile. File content would be as below :
```JSON
{
    "name": "Bishal's Ubuntu",
    "dockerFile": "Dockerfile",
    "runArgs": ["--privileged"],

    "postCreateCommand": "ansible --version && terraform --version && aws --version",
    "remoteUser": "root",
    "customizations": {
		// Configure properties specific to VS Code.
		"vscode": {
			"extensions": [
				"redhat.ansible",
				"magicstack.magicpython",
				"redhat.vscode-yaml",
				"Tobias-Faller.vt100-syntax-highlighting",
                "hashicorp.terraform",
                "pejmannikram.vscode-auto-scroll"
			]
		}
	},
    "mounts": [
        "source=${localWorkspaceFolder},target=/workspace,type=bind,consistency=cached"
    ]
}
```
4. Having these files, you would be able to use the `Reopen in Container` option in vscode to automatically open a `public image: Ubuntu` based container inside your vscode with `ansible, aws CLI, and Terraform` installed in it.
5. Verify the complete setup by hovering over `Containers` tab in your Docker Desktop application.
![alt text](image.png)

NOTE: If you wish, you can alter the contents of the Dockerfile and devcontainer.json according to your needs.

HAPPY CODING!! :)
