FROM ubuntu:24.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
ENV HOME=/home/vscode
WORKDIR /home/vscode

# Install base packages and dependencies for nRF SDK development
RUN apt-get update && apt-get install -y \
    # Core build tools
    wget \
    ca-certificates \
    git \
    ninja-build \
    gperf \
    ccache \
    dfu-util \
    device-tree-compiler \
    # Python and pip
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    python3-setuptools \
    python3-wheel \
    # Documentation build tools
    graphviz \
    lcov \
    mscgen \
    plantuml \
    doxygen \
    # Hardware support
    qemu-system-arm \
    udev \
    # X11 libraries for GUI tools
    libxcb-render-util0 \
    libxcb-shape0 \
    libxcb-icccm4 \
    libxcb-keysyms1 \
    libxcb-image0 \
    libxkbcommon-x11-0 \
    libsm6 \
    libice6 \
    # Utilities
    curl \
    file \
    make \
    cmake \
    unzip \
    sudo \
    software-properties-common \
    # Clean up
    && rm -rf /var/lib/apt/lists/*

# Install latest CMake from Kitware
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null \
    && echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null \
    && apt-get update \
    && apt-get install -y cmake \
    && rm -rf /var/lib/apt/lists/*

# Create vscode user with sudo privileges
RUN groupadd --gid 1000 vscode \
    && useradd --uid 1000 --gid 1000 -m vscode -s /bin/bash \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/vscode \
    && chmod 0440 /etc/sudoers.d/vscode

# Switch to vscode user
USER vscode
ENV HOME=/home/vscode
WORKDIR /home/vscode

# Install nrfutil and toolchain-manager
RUN wget https://files.nordicsemi.com/artifactory/swtools/external/nrfutil/executables/x86_64-unknown-linux-gnu/nrfutil -q -O /tmp/nrfutil \
    && sudo mv /tmp/nrfutil /usr/local/bin/nrfutil \
    && sudo chmod +x /usr/local/bin/nrfutil \
    && nrfutil install toolchain-manager=0.15.0

# Install west (Zephyr's meta-tool)
RUN pip3 install --user --no-cache-dir west

# Set up PATH for user-installed Python packages
ENV PATH="/home/vscode/.local/bin:${PATH}"

# Prepare JLink directory structure for later installation
USER root
RUN mkdir -p /jlink && chown -R vscode:vscode /jlink
COPY --chmod=0555 scripts/docker/jlink/ /jlink/
RUN wget --post-data="accept_license_agreement=accepted&submit=Download+software" -O /jlink/JLink_Linux.deb \
    https://www.segger.com/downloads/jlink/JLink_Linux_V876_x86_64.deb

# Add interactive-setup script
COPY --chmod=0555 scripts/docker/interactive-setup.sh /home/vscode/.bashrc.d/interactive-setup.sh
RUN mkdir -p /home/vscode/.bashrc.d \
    && echo 'if [ -f /home/vscode/.bashrc.d/interactive-setup.sh ]; then source /home/vscode/.bashrc.d/interactive-setup.sh; fi' >> /home/vscode/.bashrc \
    && chown -R vscode:vscode /home/vscode/.bashrc.d

# Add non-interactive-setup script
COPY scripts/docker/non-interactive-setup.sh /home/vscode/non-interactive-setup.sh
RUN chmod +x /home/vscode/non-interactive-setup.sh
ENV BASH_ENV=/home/vscode/non-interactive-setup.sh

USER vscode

# Set default shell to bash
SHELL ["/bin/bash", "-c"]
ENV SHELL=/bin/bash

# Create workspace directory
RUN mkdir -p /home/vscode/workspace

WORKDIR /home/vscode

# Container metadata
LABEL org.opencontainers.image.source=https://github.com/nrfconnect/sdk-nrf
LABEL org.opencontainers.image.description="Development container for nRF Connect SDK with toolchain and documentation build support"
LABEL org.opencontainers.image.title="nRF Connect SDK Dev Container"

CMD ["/bin/bash"]
