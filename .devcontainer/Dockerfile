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
