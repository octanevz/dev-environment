#!/bin/bash
set -e;

# -------------------------------------
# Powerline Fonts and TTF MS Core Fonts
# -------------------------------------
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections;
sudo apt update -y \
  && sudo apt upgrade -y \
  && sudo apt install -y \
      fonts-powerline \
      ttf-mscorefonts-installer \
  && sudo apt autoremove -y \
  && sudo apt clean -y;

# -------------------
# JetBrains Mono Font
# -------------------

# Clean up any previous downloads
rm -rf /tmp/JetBrainsMono-2.304.zip /tmp/JetBrainsMono;
sudo rm -rf /usr/share/fonts/truetype/jetbrains-mono;

# Download and unzip the font file
wget https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip -O /tmp/JetBrainsMono-2.304.zip;
unzip /tmp/JetBrainsMono-2.304.zip -d /tmp/JetBrainsMono;

# Move font files to system fonts directory and update font cache
sudo mkdir -p /usr/share/fonts/truetype/jetbrains-mono;
sudo mv /tmp/JetBrainsMono/fonts/ttf /usr/share/fonts/truetype/jetbrains-mono;
sudo fc-cache -f -v;

# Clean up
rm -rf /tmp/JetBrainsMono-2.304.zip /tmp/JetBrainsMono;
