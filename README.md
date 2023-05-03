
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

### i3 things

To use i3, you can install it with `make i3`, can log out and, at the time to
login, click on the settings wheel and select i3

### Links

Important links:
- [Third party plugins](https://github.com/williamboman/nvim-lsp-installer/blob/main/lua/nvim-lsp-installer/servers/pylsp/README.md)

Important links
- [Zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
- [Oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
- [Install plugins](https://dev.to/kumareth/a-beginner-s-guide-for-setting-up-autocomplete-on-ohmyzsh-hyper-with-plugins-themes-47f2)
