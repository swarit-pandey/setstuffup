#!/bin/bash
set -e

function command_exists() {
    command -v "$1" >/dev/null 2>&1
}

function install_zsh() {
    if command_exists apt; then
        sudo apt update && sudo apt install -y zsh
    elif command_exists apt-get; then
        sudo apt-get update && sudo apt-get install -y zsh
    elif command_exists aptitude; then
        sudo aptitude update && sudo aptitude install -y zsh
    elif command_exists zypper; then
        sudo zypper install -y zsh
    elif command_exists pacman; then
        sudo pacman -Sy --noconfirm zsh
    elif command_exists xbps-install; then
        sudo xbps-install -Sy zsh
    elif command_exists dnf; then
        sudo dnf install -y zsh
    elif command_exists yum; then
        sudo yum update && sudo yum install -y zsh
    elif command_exists eopkg; then
        sudo eopkg it -y zsh
    elif command_exists emerge; then
        sudo emerge app-shells/zsh
    elif command_exists apk; then
        sudo apk add zsh
    elif command_exists pkg; then
        pkg install zsh
    elif command_exists kiss; then
        kiss b zsh && kiss i zsh
    elif command_exists slackpkg; then
        sudo slackpkg update && sudo slackpkg install zsh
    else
        echo "Error: Unable to detect package manager. Please install Zsh manually."
        exit 1
    fi
}

function set_zsh_default() {
    if command_exists chsh; then
        sudo chsh -s "$(command -v zsh)" "$USER"
    elif command_exists usermod; then
        sudo usermod -s "$(command -v zsh)" "$USER"
    else
        echo "Warning: Unable to set Zsh as default shell automatically."
        echo "Please set Zsh as your default shell manually using 'chsh -s $(command -v zsh)' or by editing /etc/passwd."
    fi
}

function install_oh_my_zsh() {
    if command_exists curl; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    elif command_exists wget; then
        sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "Error: Neither curl nor wget is available. Cannot install Oh My Zsh."
        return 1
    fi
}

function main() {
    local install_omz=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            --oh-my-zsh)
                install_omz=true
                shift
                ;;
            *)
                echo "Usage: $0 [--oh-my-zsh]"
                exit 1
                ;;
        esac
    done

    if ! command_exists zsh; then
        echo "Zsh is not installed. Installing..."
        install_zsh
    else
        echo "Zsh is already installed."
    fi

    set_zsh_default

    # Install Oh My Zsh if requested
    if $install_omz; then
        echo "Installing Oh My Zsh..."
        install_oh_my_zsh
    fi

    echo "Zsh setup complete. Please log out and log back in for changes to take effect."
    echo "After logging back in, Zsh will guide you through its initial setup process."
}

main "$@"
