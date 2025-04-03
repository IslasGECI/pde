FROM islasgeci/base:latest

# Instala paquetes en el sistema operativo
RUN apt update && apt full-upgrade --yes && apt install --yes \
    fd-find \
    pip \
    python3-venv \
    ripgrep \
    universal-ctags \
    wget \
    && \
    apt clean

# Instala modulos con pip
RUN pip install --upgrade pip && pip install \
    rope

# Install Node
ENV NODE_VERSION=22
RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

# Instala modulos con npm
RUN npm install --global \
    pyright

# Instala paquetes de R
RUN Rscript -e "install.packages('languageserver', repos='http://cran.rstudio.com')"

# Install Neovim
RUN wget --directory-prefix="/root" https://github.com/neovim/neovim/releases/download/stable/nvim.appimage && \
    chmod u+x /root/nvim.appimage && \
    cd /root && /root/nvim.appimage --appimage-extract && \
    ln -s /root/squashfs-root/AppRun /usr/bin/nvim

# Setup Neovim kickstart configuration
RUN mkdir --parents /root/.config && \
    git clone https://github.com/nvim-lua/kickstart.nvim.git /root/.config/nvim && \
    echo 'require("vimrc")' >> /root/.config/nvim/init.lua

# Download Copilot plugin
RUN git clone https://github.com/github/copilot.vim.git /root/.config/nvim/pack/github/start/copilot.vim

COPY dotfiles/. /root/
