
.PHONY: packages
packages:
	@sudo apt install tree -y

.PHONY: neovim
neovim:
	@sudo apt install neovim ripgrep fzf python3-neovim -y && \
		pip install mypy flake8 isort pycln autoflake8 autoimport autopep8 && \
		sudo apt install neovim -y && \
		mkdir -p ~/.config/nvim && \
		touch ~/.config/nvim/init.lua && \
		cp -r ./.config/nvim ~/.config
	
	@sudo apt install curl && \
		curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
		sudo apt install nodejs && \
		node --version && \
		npm --version

.PHONY: i3
i3:
	@sudo apt update && \
	sudo apt install i3 brightnessctl maim xclip copyq xdotool -y && \
	sudo usermod -aG video $USER && \
	cp -r ./.config/i3 ~/.config && \
	cp -r ./.config/i3status ~/.config

.PHONY: chrome
chrome:
	@sudo apt update -y && \
		wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
		sudo apt install ./google-chrome-stable_current_amd64.deb && \
		sudo rm -rf ./google-chrome-stable_current_amd64.deb


.PHONY: github-desktop
githbub-desktop:
	@sudo apt update && \
		sudo apt install git -y && \
		sudo wget https://github.com/shiftkey/desktop/releases/download/release-3.2.1-linux1/GitHubDesktop-linux-3.2.1-linux1.deb && \
		sudo apt-get install gdebi-core -y && \
		sudo gdebi GitHubDesktop-linux-3.2.1-linux1.deb && \
		sudo rm -rf GitHubDesktop-linux-3.2.1-linux1.deb

.PHONY: notion
notion:
	@sudo apt update && \
		sudo apt install snapd && \
		sudo snap install notion-snap-reborn
		cp ./.zshrc ~/.config/.zshrc

.PHONY: zsh
zsh:
	@sudo apt install zsh curl -y && \
		chsh -s $(which zsh) && \
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
		sudo git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
		sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
		cp ./.zshrc ~/.zshrc

	