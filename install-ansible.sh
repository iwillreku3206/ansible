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
    dialog --no-tags --clear --title "GPU Driver" --menu "Please select a GPU driver:" 15 40 4 intel Intel amd AMD nvidia NVIDIA none None 2>&1 >/dev/tty
  )
fi

read -n1 -r -p "Press any key to continue..." key

ansible-galaxy collection install kewlfft.aur
ansible-playbook --ask-vault-pass -e gpu_driver=$GPU_DRIVER -e @vars.yml bootstrap.yml
