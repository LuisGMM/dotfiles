
.PHONY: packages
packages:
	@sudo apt install lxappearance tree htop neofetch pip curl -y && \
		curl -sS https://bootstrap.pypa.io/get-pip.py | python3 && \
		pip install thefuck && \
		pip install -U setuptools


.PHONY: neovim
neovim:
	@sudo apt update && \
	sudo apt install software-properties-common make -y&& \
		sudo apt install ninja-build gettext cmake unzip curl -y && \
		sudo apt install git pip ripgrep fzf python3-neovim python3-venv -y \
		&& \
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
		curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash - && \
		sudo apt install nodejs -y && \
		node --version && \
		npm --version

	@-nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
	@-nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
	@-nvim --headless +TransparentEnable +qa
	@cp -r .config/nvim/after/ ~/.config/nvim/ && \
		cp .config/nvim/lua/initializer/colorscheme.lua ~/.config/nvim/lua/initializer/

.PHONY: neovim_tex
neovim_tex:
	@ : \
	&& sudo apt update \
	&& sudo apt install -y \
        latexmk \
	texlive-full \
	texlive-latex-base \
	texlive-fonts-recommended \
	texlive-fonts-extra \
	texlive-latex-extra \
	\
	zathura \
	zathura-pdf-poppler \
	\
	xdotool \
	\
	libfuse2 \
	\
	perl \
	&& sudo cpan -i App::cpanminus \
	&& \
	sudo cpanm YAML::Tiny && \
	sudo cpanm File::HomeDir && \
	sudo cpanm Unicode::GCString && \
	sudo cpanm Log::Log4perl && \
	sudo cpanm Log::Dispatch::File \
	&& :


.PHONY: i3
i3:
	@sudo apt update && \
	sudo apt install i3 brightnessctl maim xclip copyq xdotool blueman -y && \
	sudo usermod -aG video $$USER && \
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

.PHONY: zsh
zsh:
	@sudo apt install zsh curl -y && \
		chsh -s $$(which zsh) && \
		sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
		sudo git clone https://github.com/zsh-users/zsh-autosuggestions $${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
		sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
		cp ./.zshrc ~/.zshrc

.PHONY: docker
docker:
	@sudo apt update && \
		sudo apt install apt-transport-https ca-certificates curl software-properties-common -y && \
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
		sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && \
		apt-cache policy docker-ce && \
		sudo apt install docker-ce -y

	@-sudo systemctl status docker

	@-sudo groupadd docker

	@sudo usermod -aG docker $${USER} && \
		newgrp docker
