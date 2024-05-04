#!/bin/bash

if [ -f /etc/arch-release ]
then
  sudo pacman --noconfirm -Sy ansible ansible-core dialog
fi

if [ -f /etc/debian_version ]
then
  sudo apt-get install -y ansible dialog
fi

if [ $(uname) == "Darwin" ]
then
  # install brew first
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew install ansible dialog
fi

# Prompt for GPU Driver (Linux only)

if [ $(uname) == "Linux" ]
then
  export GPU_DRIVER=$(
    dialog --title "GPU Driver" --menu "Please select a GPU driver:" 15 40 4 1 Intel 2 AMD 3 NVIDIA 4 None
  )
fi

echo Driver: $GPU_DRIVER

read -n1 -r -p "Press any key to continue..." key

ansible-galaxy collection install kewlfft.aur
ansible-playbook --ask-vault-pass -e @vars.yml bootstrap.yml
