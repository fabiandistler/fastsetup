# fastsetup
> Setup all the things

First, do basic ubuntu configuration, such as updating packages, and turning on auto-updates:

```
sudo apt update && sudo apt -y install git
git clone https://github.com/fabiandistler/fastsetup.git
cd fastsetup
sudo ./ubuntu-wsl.sh
```

Then, optionally, set up [dotfiles](https://github.com/fabiandistler/dotfiles):

    source dotfiles.sh

...and set up conda:

```
source setup-conda.sh
. ~/.bashrc
conda install -yq mamba
```

...and set up R with rig:

```
source install-r.sh
. ~/.bashrc
```

