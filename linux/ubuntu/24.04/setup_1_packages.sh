#!/bin/bash
set -e;

# Update OS and install some required packages
sudo apt update -y \
  && sudo apt upgrade -y \
  && sudo apt install -y \
      btop \
      ca-certificates \
      curl \
      gimp \
      git \
      gnome-keyring \
      gnome-shell-extension-manager \
      gnome-shell-extensions \
      gnome-tweaks \
      gpg \
      libc6 \
      libfontconfig1 \
      libfuse2 \
      libgcc-s1 \
      libicu-dev \
      libicu74 \
      libjpeg-turbo8 \
      liblttng-ust1 \
      libsecret-1-0 \
      libsecret-1-dev \
      libssl3 \
      libstdc++6 \
      lsb-release \
      mesa-utils \
      neofetch \
      open-vm-tools-desktop \
      unzip \
      wget \
      zlib1g \
      zsh \
      zsh-autosuggestions \
      zsh-syntax-highlighting \
  && sudo apt autoremove -y \
  && sudo apt clean -y;

# Install/Update Snap Packages
sudo snap refresh;
