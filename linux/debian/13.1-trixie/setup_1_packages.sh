#!/bin/bash
set -e;

# =========================================================================
# This script performs the following tasks:
# - Updates the OS and installs required packages
# - Installs Docker Engine and Containerd
# - Installs Visual Studio Code
# - Installs Oh My Zsh with autosuggestions and syntax highlighting plugins
# - Optionally reboots the system after installation
# =========================================================================

# --------------------------------------------
# Update OS and install some required packages
# --------------------------------------------
sudo apt update -y \
    && sudo apt upgrade -y \
    && sudo apt install -y \
        apt-transport-https \
        btop \
        ca-certificates \
        curl \
        fastfetch \
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
        libicu76 \
        liblttng-ust1 \
        libsecret-1-0 \
        libsecret-1-dev \
        libssl3 \
        libstdc++6 \
        lsb-release \
        mesa-utils \
        open-vm-tools-desktop \
        unzip \
        wget \
        zlib1g \
        zsh \
        zsh-autosuggestions \
        zsh-syntax-highlighting \
    && sudo apt autoremove -y \
    && sudo apt clean -y;

# ------------------------------------
# Install Docker Engine and Containerd
# ------------------------------------

# uninstall all conflicting packages
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt remove $pkg; done

# Add Docker's official GPG key:
sudo apt update;
sudo apt install ca-certificates curl;
sudo install -m 0755 -d /etc/apt/keyrings;
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc;
sudo chmod a+r /etc/apt/keyrings/docker.asc;

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update;

# Install latest version of Docker Engine and containerd
sudo apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin;

# Post-installation steps: manage Docker as a non-root user
sudo groupadd docker || true;
sudo usermod -aG docker $USER;

# --------------------------
# Install Visual Studio Code
# --------------------------

# Import the Microsoft GPG key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg;
sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg;
rm -f microsoft.gpg;

# Add the VS Code repository to the sources list
sudo tee /etc/apt/sources.list.d/vscode.sources <<EOF
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF

# Update package lists and install VS Code
sudo apt update;
sudo apt install code;

# -----------------------------
# Install Oh My Zsh and plugins
# -----------------------------

# Function to print messages
log() {
    echo -e "\e[32m$1\e[0m";
}

# Check for argument and set default if none provided
MAKE_DEFAULT_SHELL="${1:-yes}";

# Display the selected option
log "Make Zsh default shell: $MAKE_DEFAULT_SHELL";

# Install Oh My Zsh if not already installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    log "Oh My Zsh is already installed at $HOME/.oh-my-zsh. Skipping installation.";
else
    log "Installing Oh My Zsh...";
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended;
fi

# Set Zsh as the default shell if requested
if [[ "$MAKE_DEFAULT_SHELL" == "yes" ]]; then
    log "Setting Zsh as the default shell...";
    chsh -s $(which zsh);
else
    log "Zsh installation complete. Skipping setting it as the default shell.";
fi

# Install Zsh autosuggestions
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    log "Installing Zsh autosuggestions...";
    git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions;
else
    log "Zsh autosuggestions already installed. Skipping.";
fi

# Install Zsh syntax highlighting
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    log "Installing Zsh syntax highlighting...";
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting;
else
    log "Zsh syntax highlighting already installed. Skipping.";
fi

# Update .zshrc to enable plugins
log "Configuring Zsh plugins in .zshrc...";
if ! grep -q "zsh-autosuggestions" ~/.zshrc; then
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc;
    log "Updated plugins in .zshrc.";
else
    log "Plugins already configured in .zshrc.";
fi

# Apply changes
log "Applying changes...";
zsh -c "source ~/.zshrc";

log "Oh My Zsh installation completed with autosuggestions and syntax highlighting enabled!";

# -------------------------
# Reboot after installation
# -------------------------
read -r -p "Reboot? (j/N): " reply;
if [[ "$reply" =~ ^[JjYy]$ ]]; then
    echo "Rebooting...";
    exec sudo /sbin/reboot now;
fi