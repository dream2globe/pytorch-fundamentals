ARG BASE_IMAGE
FROM ${BASE_IMAGE}

RUN apt update -y && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git \ 
    build-essential \ 
    libssl-dev zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    curl \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir -p /app

ARG PYTHON
ENV NAME="shyeon"
ENV PYTHONPATH="${PYTHONPATH}:/app"
ENV PYTHON_VER="${PYTHON}"
ENV PYENV_ROOT="/home/$NAME/.pyenv"
ENV PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"

RUN useradd -ms /bin/bash $NAME
USER $NAME
WORKDIR /app

RUN echo "${PYTHON_VER}"
RUN git clone --depth=1 https://github.com/pyenv/pyenv.git ${PYENV_ROOT} && \
    pyenv install ${PYTHON_VER} && \
    pyenv global ${PYTHON_VER}
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir \
    torch \ 
    torchvision \
    torchaudio \
    seaborn \
    pandas \
    jupyterlab

EXPOSE 8888
ENTRYPOINT ["/bin/bash", "-c", "jupyter lab --ip=0.0.0.0 --port=8888 --no-browser"]