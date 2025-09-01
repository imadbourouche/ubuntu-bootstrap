#!/bin/bash

set -e

echo "🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing essentials..."
sudo apt install -y \
    curl wget gnupg ca-certificates apt-transport-https \
    software-properties-common unzip build-essential \
    zsh terminator flameshot git

# -----------------------------
# Docker
# -----------------------------
echo "🐳 Installing Docker..."
sudo apt remove -y docker docker-engine docker.io containerd runc || true
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER

# -----------------------------
# Google Chrome
# -----------------------------
echo "🌐 Installing Google Chrome..."
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# -----------------------------
# Brave Browser
# -----------------------------
echo "🦁 Installing Brave..."
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
  https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] \
  https://brave-browser-apt-release.s3.brave.com/ stable main" | \
  sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y brave-browser

# -----------------------------
# VS Code
# -----------------------------
echo "📝 Installing VS Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] \
  https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm microsoft.gpg
sudo apt update
sudo apt install -y code

# -----------------------------
# IntelliJ IDEA (Community)
# -----------------------------
echo "💡 Installing IntelliJ IDEA..."
sudo snap install intellij-idea-community --classic

# -----------------------------
# JDK 21
# -----------------------------
echo "☕ Installing JDK 21..."
sudo apt install -y openjdk-21-jdk

# -----------------------------
# Ruby + rbenv
# -----------------------------
echo "💎 Installing Ruby + rbenv..."
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
exec $SHELL
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
~/.rbenv/bin/rbenv install 3.3.0
~/.rbenv/bin/rbenv global 3.3.0

# -----------------------------
# Discord
# -----------------------------
echo "🎧 Installing Discord..."
wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
sudo apt install -y ./discord.deb
rm discord.deb

# -----------------------------
# Slack
# -----------------------------
echo "💬 Installing Slack..."
wget -O slack.deb "https://downloads.slack-edge.com/releases/linux/4.37.101/prod/x64/slack-desktop-4.37.101-amd64.deb"
sudo apt install -y ./slack.deb
rm slack.deb

# -----------------------------
# ProtonVPN
# -----------------------------
echo "🔒 Installing ProtonVPN..."
wget -q -O - https://repo.protonvpn.com/debian/public_key.asc | sudo apt-key add -
echo "deb https://repo.protonvpn.com/debian stable main" | \
  sudo tee /etc/apt/sources.list.d/protonvpn.list
sudo apt update
sudo apt install -y protonvpn

# -----------------------------
# Windsurf (assuming Windsurf IDE)
# -----------------------------
echo "🌊 Installing Windsurf..."
wget -O windsurf.deb "https://windsurf.dev/download?platform=linux&arch=amd64&package=deb"
sudo apt install -y ./windsurf.deb
rm windsurf.deb

# -----------------------------
# Oh-My-Zsh
# -----------------------------
echo "⚡ Installing Oh-My-Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  chsh -s $(which zsh)
  echo "🎉 Oh-My-Zsh installed. Default shell set to Zsh."
else
  echo "Oh-My-Zsh already installed."
fi

echo "✅ All done! Reboot recommended."
