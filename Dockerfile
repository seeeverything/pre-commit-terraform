FROM python:alpine3.13

ARG PRE_COMMIT_VERSION="2.11.1"
ARG TERRAFORM_VERSION="0.13.7"
ARG TFSEC_VERSION="v0.39.21"
ARG TERRAFORM_DOCS_VERSION="v0.12.0"
ARG TFLINT_VERSION="v0.27.0"
ARG CHECKOV_VERSION="1.0.838"
ARG TERRASCAN_VERISON="1.6.0"

# Install general dependencies
RUN apk add --no-cache curl git gawk unzip gnupg bash

# Install tools
RUN pip install pre-commit==${PRE_COMMIT_VERSION} && \
    curl -L "$(curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases | grep -o -E "https://.+?${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz")" > terraform-docs.tgz && tar xzf terraform-docs.tgz && chmod +x terraform-docs && mv terraform-docs /usr/bin/ && \
    curl -L "$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases | grep -o -E "https://.+?/${TFLINT_VERSION}/tflint_linux_amd64.zip")" > tflint.zip && unzip tflint.zip && rm tflint.zip && mv tflint /usr/bin/ && \
    curl -L "$(curl -s https://api.github.com/repos/tfsec/tfsec/releases | grep -o -E "https://.+?/${TFSEC_VERSION}/tfsec-linux-amd64")" > tfsec && chmod +x tfsec && mv tfsec /usr/bin/ && \
    curl -L "$(curl -s https://api.github.com/repos/accurics/terrascan/releases | grep -o -E "https://.+?/v${TERRASCAN_VERISON}/terrascan_${TERRASCAN_VERISON}_Linux_x86_64.tar.gz")" > terrascan.tgz && tar xzf terrascan.tgz && chmod +x terrascan && mv terrascan /usr/bin/ && \
    pip install -U checkov==${CHECKOV_VERSION}

RUN wget -O terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && unzip terraform.zip && chmod +x terraform && mv terraform /usr/bin/ && \
    rm terraform.zip

# Checking all binaries are in the PATH
RUN terraform --help
RUN pre-commit --help
RUN terraform-docs --help
RUN tflint --help
RUN tfsec --help
RUN checkov --help
RUN terrascan --help

ENTRYPOINT [ "pre-commit" ]
