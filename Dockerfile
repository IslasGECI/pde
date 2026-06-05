FROM islasgeci/base:latest

RUN apt update && apt full-upgrade --yes && apt install --yes \
	curl \
	fd-find \
	pip \
	ripgrep \
	universal-ctags \
	wget \
	&& \
	apt clean

RUN apt remove neovim --yes

# Instala modulos con pip
RUN pip install --upgrade pip && pip install \
	rope

# Install Node
ENV NODE_VERSION=22
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"


# Instala paquetes de R
RUN Rscript -e "install.packages('languageserver', repos='http://cran.rstudio.com')"

# Install Neovim
RUN wget --directory-prefix="/root" https://github.com/neovim/neovim/releases/download/v0.12.0/nvim-linux-x86_64.appimage && \
	chmod u+x /root/nvim-linux-x86_64.appimage && \
	cd /root && /root/nvim-linux-x86_64.appimage --appimage-extract && \
	ln -s /root/squashfs-root/AppRun /usr/bin/nvim

# Setup Neovim kickstart configuration
RUN mkdir --parents /root/.config && \
	git clone https://github.com/nvim-lua/kickstart.nvim.git /root/.config/nvim && \
	echo 'require("vimrc")' >> /root/.config/nvim/init.lua

# Download Copilot plugin
RUN git clone https://github.com/github/copilot.vim.git /root/.config/nvim/pack/github/start/copilot.vim


# Instala opencode
RUN apt install -y lsof
RUN curl -fsSL https://opencode.ai/install | bash
RUN export PATH=$PATH:$HOME/.opencode/bin
# Instala opencode.nvim
COPY opencode.lua /root/.config/nvim/lua/custom/plugins/
# Instala custom plugins
RUN sed -i "s/-- { import = 'custom.plugins' }/{ import = 'custom.plugins' }/" /root/.config/nvim/init.lua

COPY dotfiles/. /root/
