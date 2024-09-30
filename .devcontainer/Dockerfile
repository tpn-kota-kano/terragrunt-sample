FROM debian:bookworm-20240926-slim

# git, curl, zip, unzip, jq, tree => for development
# less => for AWSCLI
RUN apt-get update \
    && apt-get install -y \
        git \
        curl \
        zip \
        unzip \
        jq \
        tree \
        less \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install awscliv2
ARG AWSCLI_VER=2.17.18
RUN curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VER}.zip -o awscliv2.zip \
    && unzip -q awscliv2.zip \
    && aws/install

# install session-manager-plugin
RUN curl -sL https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb -o temp.deb \
    && dpkg -i temp.deb \
    && rm temp.deb

# install terraform
ARG TERA_VER=1.9.3
RUN curl -sL https://releases.hashicorp.com/terraform/${TERA_VER}/terraform_${TERA_VER}_linux_amd64.zip -o terraform.zip \
    && unzip -q ./terraform.zip -d /usr/local/bin/ \
    && rm -f ./terraform.zip

# install terragrunt
ARG TERA_GRUNT_VER=0.67.1
RUN curl -sL https://github.com/gruntwork-io/terragrunt/releases/download/v${TERA_GRUNT_VER}/terragrunt_linux_amd64 -o terragrunt \
    && chmod +x terragrunt \
    && mv terragrunt /usr/local/bin/ \
    && terragrunt --install-autocomplete

# setting for terraform and terragrunt
RUN echo 'alias tf="terraform"' >> ~/.bashrc \
    && echo 'alias tg="terragrunt"' >> ~/.bashrc

CMD [ "sleep", "infinity" ]
