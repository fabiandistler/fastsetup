# fastsetup
> Setup all the things

First, do basic ubuntu configuration, such as updating packages, and turning on auto-updates:

```
sudo apt update && sudo apt -y install git
git clone https://github.com/fabiandistler/fastsetup.git
cd fastsetup
sudo ./ubuntu-wsl.sh

# Automatic updates
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

Then, optionally, set up [dotfiles](https://github.com/fabiandistler/dotfiles):

    source dotfiles.sh

Set up bash-it:

```
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh

echo "source .bashrc.local" >> ~/.bashrc
```

...and set up R with rig:

```
source install-r.sh
. ~/.bashrc
```

...and set up conda:

```
source setup-conda.sh
. ~/.bashrc
conda install -yq mamba
```



Set up pet as snippet manager:

```
gh release download --repo knqyf263/pet --pattern "*linux_amd64.deb"
sudo dpkg -i *linux_amd64.deb
# Set up gist sync with pet configure
```


