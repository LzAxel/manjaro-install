#!/bin/bash
# Проверка, что скрипт запущен с правами root
if [ "$EUID" -ne 0 ]; then
  echo "Запустите скрипт с sudo: sudo $0"
  exit 1
fi

# Обновление системы
echo "Обновление системы..."
pacman -Syu --noconfirm || { echo "Failed to update system"; exit 1; }

# Установка базовых утилит
echo "Установка базовых утилит (git, curl, wget, unzip, make)..."
pacman -S --noconfirm git curl wget unzip make || { echo "Failed to install base utilities"; exit 1; }

# Установка yay (AUR helper)
echo "Установка yay (AUR helper)..."
git clone https://aur.archlinux.org/yay.git /tmp/yay || { echo "Failed to clone yay repository"; exit 1; }
cd /tmp/yay
makepkg -si --noconfirm || { echo "Failed to install yay"; exit 1; }
cd -
rm -rf /tmp/yay

# Установка системных утилит
echo "Установка htop, tmux, zsh..."
pacman -S --noconfirm htop tmux zsh || { echo "Failed to install system utilities"; exit 1; }

# Установка Visual Studio Code
echo "Установка Visual Studio Code..."
pacman -S --noconfirm code || { echo "Failed to install VS Code"; exit 1; }

# Установка Node.js через nvm
echo "Установка Node Version Manager (nvm) и последней стабильной версии Node.js..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash || { echo "Failed to install nvm"; exit 1; }
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node || { echo "Failed to install Node.js"; exit 1; }
nvm use node
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc

# Установка npm и глобальных инструментов
echo "Установка глобальных инструментов npm (vite, webpack, webpack-cli)..."
npm install -g vite webpack webpack-cli || { echo "Failed to install npm tools"; exit 1; }

# Установка Python и pip
echo "Установка Python и pip..."
pacman -S --noconfirm python python-pip || { echo "Failed to install Python"; exit 1; }

# Установка Go
echo "Установка Go..."
pacman -S --noconfirm go || { echo "Failed to install Go"; exit 1; }

# Установка Java (Zulu 17 JDK) from official website using tar file
echo "Установка Zulu 17 JDK from official website..."
ZULU_TAR_URL="https://cdn.azul.com/zulu/bin/zulu17.52.17-ca-jdk17.0.12-linux_x64.tar.gz"
ZULU_TAR_FILE="zulu17.52.17-ca-jdk17.0.12-linux_x64.tar.gz"

# Download the tar file
wget -O /tmp/$ZULU_TAR_FILE $ZULU_TAR_URL || { echo "Failed to download Zulu 17 JDK"; exit 1; }

# Extract to /opt
echo "Extracting Zulu 17 JDK..."
mkdir -p /opt/zulu-17
tar -xzf /tmp/$ZULU_TAR_FILE -C /opt/zulu-17 --strip-components=1 || { echo "Failed to extract Zulu 17 JDK"; exit 1; }

# Verify installation
if /opt/zulu-17/bin/java -version 2>&1 | grep -q "openjdk version \"17"; then
  echo "Zulu 17 JDK installed successfully."
else
  echo "Failed to verify Zulu 17 JDK installation"
  exit 1
fi

# Optional: Add to PATH and set JAVA_HOME
echo "Setting up environment variables for Java..."
echo 'export JAVA_HOME=/opt/zulu-17' >> ~/.zshrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.zshrc

# Установка IntelliJ IDEA Ultimate from official website
echo "Установка IntelliJ IDEA Ultimate from official website..."
INTELLIJ_TAR_URL="https://download.jetbrains.com/idea/ideaIU-2024.2.4.tar.gz"
INTELLIJ_TAR_FILE="ideaIU-2024.2.4.tar.gz"

# Download the tar file
wget -O /tmp/$INTELLIJ_TAR_FILE $INTELLIJ_TAR_URL || { echo "Failed to download IntelliJ IDEA"; exit 1; }

# Extract to /opt
echo "Extracting IntelliJ IDEA..."
mkdir -p /opt/intellij-idea
tar -xzf /tmp/$INTELLIJ_TAR_FILE -C /opt/intellij-idea --strip-components=1 || { echo "Failed to extract IntelliJ IDEA"; exit 1; }

# Verify installation
if /opt/intellij-idea/bin/idea.sh --version 2>&1 | grep -q "IntelliJ IDEA"; then
  echo "IntelliJ IDEA installed successfully."
else
  echo "Failed to verify IntelliJ IDEA installation"
  exit 1
fi

# Установка GoLand from official website
echo "Установка GoLand from official website..."
GOLAND_TAR_URL="https://download.jetbrains.com/go/goland-2024.2.4.tar.gz"
GOLAND_TAR_FILE="goland-2024.2.4.tar.gz"

# Download the tar file
wget -O /tmp/$GOLAND_TAR_FILE $GOLAND_TAR_URL || { echo "Failed to download GoLand"; exit 1; }

# Extract to /opt
echo "Extracting GoLand..."
mkdir -p /opt/goland
tar -xzf /tmp/$GOLAND_TAR_FILE -C /opt/goland --strip-components=1 || { echo "Failed to extract GoLand"; exit 1; }

# Verify installation
if /opt/goland/bin/goland.sh --version 2>&1 | grep -q "GoLand"; then
  echo "GoLand installed successfully."
else
  echo "Failed to verify GoLand installation"
  exit 1
fi

# Установка Docker
echo "Установка Docker..."
pacman -S --noconfirm docker docker-compose || { echo "Failed to install Docker"; exit 1; }
systemctl enable docker
systemctl start docker
usermod -aG docker $(logname)
echo "Log out and log back in for Docker group changes to take effect."

# Установка Alacritty
echo "Установка Alacritty..."
pacman -S --noconfirm alacritty || { echo "Failed to install Alacritty"; exit 1; }
# Создание базовой конфигурации Alacritty
mkdir -p ~/.config/alacritty
cat << 'EOF' > ~/.config/alacritty/alacritty.toml
[window]
padding = { x = 5, y = 5 }
decorations = "Full"

[font]
normal = { family = "MesloLGS NF", style = "Regular" }
size = 12
EOF
echo "Alacritty установлен и настроен."

# Установка Flameshot
echo "Установка Flameshot..."
pacman -S --noconfirm flameshot || { echo "Failed to install Flameshot"; exit 1; }

# Установка Flatpak и Postman
echo "Установка Flatpak и Postman..."
pacman -S --noconfirm flatpak || { echo "Failed to install Flatpak"; exit 1; }
flatpak install flathub com.getpostman.Postman -y || { echo "Failed to install Postman"; exit 1; }

# Установка Google Chrome
echo "Установка Google Chrome..."
flatpak install flathub com.google.Chrome

# Установка Bitwarden
echo "Установка Bitwarden..."
flatpak install flathub com.bitwarden.desktop

# Установка Oh My Zsh
echo "Установка Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || { echo "Failed to install Oh My Zsh"; exit 1; }
chsh -s $(which zsh) $(logname)

# Установка плагинов для zsh
echo "Установка плагинов zsh-autosuggestions и zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || { echo "Failed to install zsh-autosuggestions"; exit 1; }
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || { echo "Failed to install zsh-syntax-highlighting"; exit 1; }

# Установка шрифтов для Powerlevel10k
echo "Установка шрифтов для Powerlevel10k..."
pacman -S --noconfirm ttf-meslo-nerd-font-powerlevel10k || { echo "Failed to install Powerlevel10k fonts"; exit 1; }

# Установка темы Powerlevel10k
echo "Установка темы Powerlevel10k для zsh..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k || { echo "Failed to install Powerlevel10k"; exit 1; }

# Настройка .zshrc
echo "Настройка .zshrc..."
cat << 'EOF' > ~/.zshrc
# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set Powerlevel10k theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  docker
  node
  npm
  python
)

source $ZSH/oh-my-zsh.sh

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases
alias ll="ls -lah"
alias dc="docker-compose"
EOF

# Установка Tmux Plugin Manager и плагинов
echo "Установка Tmux Plugin Manager и плагинов..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || { echo "Failed to install Tmux Plugin Manager"; exit 1; }
cat << 'EOF' > ~/.tmux.conf
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

# Initialize TMUX plugin manager
run '~/.tmux/plugins/tpm/tpm'

# Enable mouse support
set -g mouse on

# Set prefix to Ctrl-a
unbind C-b
set -g prefix C-a
bind C-a send-prefix
EOF

# Настройка переключения раскладки на Caps Lock и горячих клавиш для Flameshot
echo "Настройка переключения раскладки на Caps Lock и горячих клавиш для Flameshot..."
if [ -n "$DESKTOP_SESSION" ] && [ "$DESKTOP_SESSION" = "gnome" ]; then
  gsettings set org.gnome.desktop.input-sources xkb-options "['caps:lock', 'grp:caps_toggle']" || { echo "Failed to configure Caps Lock"; }
  # Настройка горячих клавиш для Flameshot (Print Screen для запуска)
  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']" || { echo "Failed to set custom keybindings"; }
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Flameshot" || { echo "Failed to set Flameshot keybinding name"; }
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "flameshot gui" || { echo "Failed to set Flameshot command"; }
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "Print" || { echo "Failed to set Flameshot keybinding"; }
  echo "Flameshot hotkey set to Print Screen."
else
  echo "Skipping Caps Lock and Flameshot hotkey configuration: GNOME desktop not detected."
fi

echo "Установка завершена! Перезайдите в систему, чтобы применить изменения."