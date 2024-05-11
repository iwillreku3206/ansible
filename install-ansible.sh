#!/bin/bash

if ! command -v ansible &> /dev/null || ! command -v dialog &> /dev/null
then
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
fi

if [ $(uname) == "Linux" ]
then
  export GPU_DRIVER=$(
    dialog --no-tags --clear --title "GPU Driver" --menu "Please select a GPU driver:" 15 40 4 intel Intel amd AMD nvidia NVIDIA qxl QXL vmware VMWare none None 2>&1 >/dev/tty
  )

  export CUPS_INSTALL=$(
    dialog --no-tags --clear --title "CUPS" --menu "Do you want to install CUPS?" 15 40 2 yes Yes no No 2>&1 >/dev/tty
  )

  export WINE_INSTALL=$(
    dialog --no-tags --clear --title "Wine" --menu "Do you want to install Wine?" 15 40 2 yes Yes no No 2>&1 >/dev/tty
  )

  export GAMES_INSTALL=$(
    dialog --no-tags --clear --title "Games" --menu "Do you want to install games?" 15 40 2 yes Yes no No 2>&1 >/dev/tty
  )
fi

read -n1 -r -p "Press any key to continue..." key

ansible-galaxy collection install kewlfft.aur
ansible-playbook -v --ask-vault-pass -e GPU_DRIVER=$GPU_DRIVER -e @vars.yml bootstrap.yml
