
# nvim-config

Config file and steps to install nvim in a debian based system.

## Install neovim

Please refer to the official [neovim installation guide](https://github.com/neovim/neovim/wiki/Installing-Neovim) in case of problems. To install from package use:

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz &&
tar xzvf nvim-linux64.tar.gz &&
./nvim-linux64/bin/nvim
````

Copy the file `init.lua` into `~/.config/nvim/init.lua`. For that, you can run inside the repo folder:

```bash
mkdir -p ~/.config/nvim &&
touch ~/.config/nvim/init.lua &&
cp ./.config/nvim/init.lua ~/.config/nvim/init.lua
```

Make sure you have installed the following packages, if not install them:

```bash
pip install mypy flake8 isort pycln autoflake8 autoimport autopep8
```

Make sure you have installed nodejs, npm and all that crap. In doubt:

```bash
sudo apt install curl &&
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - &&
sudo apt install nodejs &&
node --version &&
npm --version
```
<!-- Install luarocks according to [this documentation](https://github.com/luarocks/luarocks/wiki/Installation-instructions-for-Unix): -->
<!---->
<!-- ```bash -->
<!-- sudo apt install build-essential libreadline-dev unzip && -->
<!-- curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz && -->
<!-- tar -zxf lua-5.3.5.tar.gz                          && -->
<!-- cd lua-5.3.5                                       && -->
<!-- make linux test                                    && -->
<!-- sudo make install                                  && -->
<!-- rm -rf lua-5.3.5 && -->
<!-- wget https://luarocks.org/releases/luarocks-3.8.0.tar.gz && -->
<!-- tar zxpf luarocks-3.8.0.tar.gz && -->
<!-- cd luarocks-3.8.0 && -->
<!-- ./configure --with-lua-include=/usr/local/include && -->
<!-- make && -->
<!-- sudo make install && -->
<!-- rm -rf ../luarocks-3.8.0 -->
<!-- ``` -->

After that is installed, run `nvim` to install all default packages & theme.

When done, inside neovim, open Mason package manager with `:Mason` and install the preferred packages. In this case, to develop Python, install in this order:

- lua-language-server
- pyright
- marksman
- markdownlint
- stylua
- selene

Then you can run in the neovim's command line tool:
`:PackerSync`
`:TransparentEnable`

Important links:

- [Third party plugins](https://github.com/williamboman/nvim-lsp-installer/blob/main/lua/nvim-lsp-installer/servers/pylsp/README.md)

## Install zsh & oh-my-zsh

Commands to install all you need:

```bash
sudo apt install zsh curl &&
chsh -s $(which zsh) &&
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &&
sudo git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &&
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

Important links

- [Zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
- [Oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
- [Install plugins](https://dev.to/kumareth/a-beginner-s-guide-for-setting-up-autocomplete-on-ohmyzsh-hyper-with-plugins-themes-47f2)

## Install i3

```bash
sudo apt update && \
sudo apt install i3 && \
mkdir ~/.config/i3 && \
mkdir ~/.config/i3status && \
cp -r ./.config/i3 ~/.config/i3 && \
cp -r ./.config/i3status ~/.config/i3status
```

Then you can log out and, at the time to login, click on the settings wheel and select i3
