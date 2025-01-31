#!/usr/bin/env bash
# Exit script on any error
set -e

# Function to display error message and exit
fail () { echo $1 >&2; exit 1; }

# Ensure the script is run as root using sudo
if [[ $(id -u) -ne 0 ]] || [[ -z $SUDO_USER ]]; then
    fail "Please run 'sudo $0'"
fi

# Check if running on WSL (Windows Subsystem for Linux)
if ! [[ $(grep -i Microsoft /proc/version) ]]; then
    fail "NOT running on WSL, try running 'sudo ./ubuntu-initial.sh'"
fi

# Set sudo timeout to 1 hour
echo 'Defaults        timestamp_timeout=3600' >> /etc/sudoers

# Create necessary directories and set permissions
mkdir /root/.gnupg
mkdir git
chmod 700 /root/.gnupg/

# Import GPG key for apt-fast
gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/apt-fast-keyring.gpg --keyserver keyserver.ubuntu.com --recv-keys 1EE2FF37CA8DA16B
chmod go+r /usr/share/keyrings/apt-fast-keyring.gpg

# Add apt-fast repository
CODENAME=$(lsb_release -cs)
echo "deb [signed-by=/usr/share/keyrings/apt-fast-keyring.gpg] http://ppa.launchpad.net/apt-fast/stable/ubuntu $CODENAME main" | sudo tee /etc/apt/sources.list.d/apt-fast.list

# Add GitHub CLI repository
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list

# Update package lists
apt-get update

# Set non-interactive mode for apt
export DEBIAN_FRONTEND=noninteractive

# Install apt-fast
apt-get -qy install apt-fast
cp apt-fast.conf /etc/
chown root:root /etc/apt-fast.conf

# Install necessary packages using apt-fast
apt-fast -qy install python3
apt-fast -qy install vim-nox python3-powerline rsync ubuntu-drivers-common python3-pip ack lsyncd bzip2 ca-certificates git build-essential \
  software-properties-common libglib2.0-dev zlib1g-dev lsb-release htop exuberant-ctags openssh-client python-is-python3 \
  dos2unix gh pigz ufw bash-completion ubuntu-release-upgrader-core unattended-upgrades \
  opensmtpd mailutils cron tldr bat parallel

# Perform a full system upgrade
env DEBIAN_FRONTEND=noninteractive APT_LISTCHANGES_FRONTEND=mail apt-fast full-upgrade -qy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'
sudo apt -qy autoremove

# Configure SSH to disallow password authentication
perl -ni.bak -e 'print unless /^\s*(PermitEmptyPasswords|PermitRootLogin|PasswordAuthentication|ChallengeResponseAuthentication)/' /etc/ssh/sshd_config
cat << 'EOF' >> /etc/ssh/sshd_config
PasswordAuthentication no
ChallengeResponseAuthentication no
PermitEmptyPasswords no
PermitRootLogin no
EOF

# Uncomment the following lines to reload or restart SSH service
#systemctl reload ssh
#service ssh restart

# Uncomment the following line to upgrade pip
#python -m pip install pip -Uq
