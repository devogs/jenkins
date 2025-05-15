FROM jenkins/inbound-agent:jdk17

USER root

# Install base dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl unzip git python3 python3-pip python3-venv ssh ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Link `python` to `python3`
RUN ln -sf /usr/bin/python3 /usr/bin/python

# Create and activate a virtual environment for Python packages
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir --upgrade pip && \
    /opt/venv/bin/pip install ansible==11.5.0

# Install Terraform
RUN curl -fsSL https://releases.hashicorp.com/terraform/1.1.4/terraform_1.1.4_linux_amd64.zip -o terraform.zip && \
    unzip terraform.zip && mv terraform /usr/local/bin/ && rm terraform.zip

# Copy and set entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Add virtualenv to PATH (Ansible usable globally)
ENV PATH="/opt/venv/bin:$PATH"

USER jenkins
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
