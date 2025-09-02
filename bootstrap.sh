#!/bin/bash
set -e

echo "🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing essentials..."
sudo apt install -y \
    curl wget gnupg ca-certificates apt-transport-https \
    software-properties-common unzip build-essential \
    libssl-dev libreadline-dev zlib1g-dev libffi-dev libyaml-dev \
    libgdbm-dev libncurses5-dev libdb-dev libsqlite3-dev \
    build-essential autoconf bison htop vim

# Zsh, Terminator, Flameshot, Git
for pkg in zsh terminator flameshot git; do
  if dpkg -l | grep -q "^ii\s\+$pkg"; then
    echo "✅ $pkg already installed."
  else
    echo "⬇️ Installing $pkg..."
    sudo apt install -y $pkg
  fi
done

# -----------------------------
# Docker
# -----------------------------
if command -v docker -v &>/dev/null; then
  echo "✅ Docker already installed."
else
  echo "🐳 Installing Docker..."
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo usermod -aG docker $USER
fi

# -----------------------------
# Google Chrome
# -----------------------------
if command -v google-chrome --version &>/dev/null; then
  echo "✅ Google Chrome already installed."
else
  echo "🌐 Installing Google Chrome..."
  wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install -y ./google-chrome-stable_current_amd64.deb
  rm google-chrome-stable_current_amd64.deb
fi

# -----------------------------
# Brave Browser
# -----------------------------
if command -v brave-browser --version &>/dev/null; then
  echo "✅ Brave already installed."
else
  echo "🦁 Installing Brave..."
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg | \
    sudo tee /etc/apt/keyrings/brave-browser-archive-keyring.gpg > /dev/null
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com stable main" | \
    sudo tee /etc/apt/sources.list.d/brave-browser-release.list
  sudo apt update
  sudo apt install -y brave-browser
fi

# -----------------------------
# VS Code
# -----------------------------
if command -v code -v &>/dev/null; then
  echo "✅ VS Code already installed."
else
  echo "📝 Installing VS Code..."
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | \
    sudo tee /etc/apt/sources.list.d/vscode.list
  sudo apt update
  sudo apt install -y code
fi

# -----------------------------
# IntelliJ IDEA (Community)
# -----------------------------
if snap list | grep -q intellij-idea-community; then
  echo "✅ IntelliJ IDEA already installed."
else
  echo "💡 Installing IntelliJ IDEA..."
  sudo snap install intellij-idea-community --classic
fi

# -----------------------------
# JDK 21
# -----------------------------
if java -version 2>&1 | grep -q "21"; then
  echo "✅ JDK 21 already installed."
else
  echo "☕ Installing JDK 21..."
  sudo apt install -y openjdk-21-jdk
fi

# -----------------------------
# Ruby + rbenv
# -----------------------------
if [ -d "$HOME/.rbenv" ]; then
  echo "✅ rbenv already installed."
else
  echo "💎 Installing Ruby + rbenv..."
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
  mkdir -p ~/.rbenv/plugins
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  ~/.rbenv/bin/rbenv install 3.2.0
  ~/.rbenv/bin/rbenv global 3.2.0
fi

# -----------------------------
# Discord
# -----------------------------
if command -v discord -v &>/dev/null; then
  echo "✅ Discord already installed."
else
  echo "🎧 Installing Discord..."
  wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
  sudo apt install -y ./discord.deb
  rm discord.deb
fi

# -----------------------------
# Slack
# -----------------------------
if command -v slack -v &>/dev/null; then
  echo "✅ Slack already installed."
else
  echo "💬 Installing Slack..."
  wget -O slack.deb "https://downloads.slack-edge.com/releases/linux/4.37.101/prod/x64/slack-desktop-4.37.101-amd64.deb"
  sudo apt install -y ./slack.deb
  rm slack.deb
fi

# -----------------------------
# ProtonVPN
# -----------------------------
if command -v protonvpn-app -v &>/dev/null; then
  echo "✅ ProtonVPN already installed."
else
  echo "🔒 Installing ProtonVPN..."
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://repo.protonvpn.com/debian/public_key.asc | sudo gpg --dearmor -o /etc/apt/keyrings/protonvpn.gpg
  echo "deb [signed-by=/etc/apt/keyrings/protonvpn.gpg] https://repo.protonvpn.com/debian stable main" | \
    sudo tee /etc/apt/sources.list.d/protonvpn.list
  sudo apt update
  sudo apt install -y protonvpn
fi

# -----------------------------
# Windsurf
# -----------------------------
if command -v windsurf --version &>/dev/null; then
  echo "✅ Windsurf already installed."
else
  echo "🌊 Installing Windsurf..."
  wget -qO- "https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/windsurf.gpg" | gpg --dearmor > windsurf-stable.gpg
  sudo install -D -o root -g root -m 644 windsurf-stable.gpg /etc/apt/keyrings/windsurf-stable.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/windsurf-stable.gpg] https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt stable main" | sudo tee /etc/apt/sources.list.d/windsurf.list > /dev/null
  rm -f windsurf-stable.gpg
  sudo apt install apt-transport-https
  sudo apt update
  sudo apt install windsurf
fi

# -----------------------------
# Oh-My-Zsh
# -----------------------------
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "✅ Oh-My-Zsh already installed."
else
  echo "⚡ Installing Oh-My-Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  chsh -s $(which zsh)
  echo "🎉 Oh-My-Zsh installed. Default shell set to Zsh."
fi

# -----------------------------
# Lazygit
# -----------------------------
if command -v lazygit -v &>/dev/null; then
  echo "✅ lazygit already installed."
else
  echo "⚡ Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar -xf /tmp/lazygit.tar.gz -C /tmp lazygit
  sudo install /tmp/lazygit -D -t /usr/local/bin/
  echo "🎉 lazygit installed."
fi

echo "🎉 Setup complete! Reboot recommended."
