
.PHONY: packages
packages:
	@sudo apt install tree htop neofetch pip curl -y && \
		curl -sS https://bootstrap.pypa.io/get-pip.py | python3 && \
		pip install thefuck

.PHONY: neovim
neovim:
	@sudo apt update && \
	sudo apt install software-properties-common make -y&& \
		sudo apt install ninja-build gettext cmake unzip curl -y && \
		sudo apt install git pip ripgrep fzf python3-neovim -y && \
		sudo apt update && \
		curl -sS https://bootstrap.pypa.io/get-pip.py | python3 && \
		sudo apt update && \
		git clone https://github.com/neovim/neovim && \
		cd neovim && \
		git checkout stable && \
		make CMAKE_BUILD_TYPE=RelWithDebInfo && \
		sudo make install && \
		cd ../ && \
		sudo rm -rf neovim && \
		pip install mypy flake8 isort pycln autoflake8 autoimport autopep8 && \
		mkdir -p ~/.config/nvim && \
		touch ~/.config/nvim/init.lua && \
		cp -r ./.config/nvim ~/.config && \
		rm -r ~/.config/nvim/after/ && \
		rm ~/.config/nvim/lua/initializer/colorscheme.lua  && \
		touch ~/.config/nvim/lua/initializer/colorscheme.lua

	@sudo apt install curl && \
		curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
		sudo apt install nodejs -y && \
		node --version && \
		npm --version

	@-nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
	@-nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
	@-nvim --headless +TransparentEnable +qa
	@cp -r .config/nvim/after/ ~/.config/nvim/ && \
		cp .config/nvim/lua/initializer/colorscheme.lua ~/.config/nvim/lua/initializer/

.PHONY: i3
i3:
	@sudo apt update && \
	sudo apt install i3 brightnessctl maim xclip copyq xdotool -y && \
	sudo usermod -aG video $USER && \
	cp -r ./.config/i3 ~/.config && \
	cp -r ./.config/i3status ~/.config && \
	cp ./.config/gtk-3.0/settings.ini ~/.config/gtk-3.0/settings.ini && \
	gsettings set org.gnome.desktop.interface color-scheme prefer-dark


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
		sudo apt install snapd -y && \
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

.PHONY: docker
docker:
	@sudo apt update && \
		sudo apt install ca-certificates curl gnupg -y && \
		sudo install -m 0755 -d /etc/apt/keyrings && \
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
		sudo chmod a+r /etc/apt/keyrings/docker.gpg && \
		sudo apt update && \
		sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y && \
		sudo groupadd docker && \
		sudo usermod -aG docker $USER && \
		newgrp docker


