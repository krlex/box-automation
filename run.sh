#!/bin/sh -uxe

install_pip () {
        $SUDO pip3 install ansible -U
        $SUDO pip3 install vex -U
        export ANSIBLE_HOST_KEY_CHECKING=False
        PATH="${HOME}/.local/bin:${PATH}"
        virtual_env="provision"
        virtual_env_path=~/.virtualenvs/$virtual_env
        vex --make $virtual_env pip3 install -U pip
        source $virtual_env_path/bin/activate
}

prepare_ubuntu() {
        $SUDO apt update -y
        $SUDO apt dist-upgrade -y
        $SUDO apt install build-essential curl sshpass vim python3-pip -y
        [ $(uname -m) == "aarch64" ] && $SUDO apt install python3-dev libffi-dev libssl-dev -y

        install_pip

        set +x
        echo
        echo "   Ubuntu Sytem ready for box-automation."
        echo
        ansible --version
}

prepare_debian() {
        $SUDO apt update -y
        $SUDO apt dist-upgrade -y
        $SUDO apt install build-essential curl sshpass vim python3-pip -y
        [ $(uname -m) == "aarch64" ] && $SUDO apt install python3-dev libffi-dev libssl-dev -y

        install_pip

        set +x
        echo
        echo "   Debian System ready for box-automation."
        echo
        ansible --version
}

prepare_fedora() {
        $SUDO dnf install vim curl python3 python3-pip -y
        $SUDO dnf update -y

        install_pip

        set +x
        echo
        echo "   Fedora System ready for box-automation."
        echo
        ansible --version
}

#prepare_freebsd() {
#        $SUDO pkg install vim-console curl py37-pip -y
#        $SUDO pkg update -y
#
#        install_pip
#
#        set +x
#        echo
#        echo "   FreeBSD System ready for box-automation."
#        echo
#        ansible --version
#}

if [  -f /etc/os-release ]; then
        . /etc/os-release
elif [ -f /etc/debian_version ]; then
      $ID=debian
fi

if [[ $EUID -ne 0 ]]; then
  SUDO='sudo -H'
else
  SUDO=''
fi

case $ID in
        'ubuntu')
                prepare_ubuntu
        ;;
        'debian')
                prepare_debian
        ;;
        'fedora')
                prepare_fedora
        ;;
        #'freebsd')
        #        prepare_freebsd
        #;;

        *)
                usage
        ;;
esac

ansible-playbook -i provision/inventory/localhost provision/site.yml -c local
rm -rf ~/.virtualenvs
