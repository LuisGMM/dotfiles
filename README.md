
# Dotfiles

Config file and steps to install stuff in a debian/ubuntu based system.

## Use Makefile to cook the meat

To be able to run make and its commands make sure to have installed these:

```bash
apt install sudo make git software-properties-common -y
```

Remember to add a sudo at the start if your user is not root.

### Nvim things

After that is installed, run `nvim` to install all default packages & theme.

When done, inside neovim, open Mason package manager with `:Mason` and install
the preferred packages. In this case, to develop Python, install in this order:

- lua-language-server
- pyright
- marksman
- markdownlint
- stylua
- selene
- cmake

Then you can run in the neovim's command line tool:
`:PackerSync`
`:TransparentEnable`

If these things will run in a docker, or you have a git error about
`safe-directory` when using neovim fugitive or telescope, try executing this command:

```bash
git config --global --add safe.directory '*'
```

Important links:
- [Git error](https://stackoverflow.com/questions/72978485/git-submodule-update-failed-with-fatal-detected-dubious-ownership-in-repositor)
- [Third party plugins](https://github.com/williamboman/nvim-lsp-installer/blob/main/lua/nvim-lsp-installer/servers/pylsp/README.md)

### i3 things

To use i3, you can install it with `make i3`, can log out and, at the time to
login, click on the settings wheel and select i3.
Also, to change the appearance to a black theme use `lxappearance`.

### Links


Important links
- [Zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
- [Oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
- [Install plugins](https://dev.to/kumareth/a-beginner-s-guide-for-setting-up-autocomplete-on-ohmyzsh-hyper-with-plugins-themes-47f2)
