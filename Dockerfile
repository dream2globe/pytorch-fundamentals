FROM pytorch/pytorch:latest

RUN useradd -ms /bin/bash shyeon
USER shyeon

ENV PATH="/home/shyeon/.local/bin:${PATH}"

RUN mkdir -p /home/shyeon/workspace
WORKDIR /home/shyeon/workspace

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir jupyterlab scikit-learn pandas seaborn xgboost lightgbm && \
    pip install --no-cache-dir --upgrade ipywidgets tqdm

ENTRYPOINT ["/bin/bash", "-c", "jupyter lab --ip=0.0.0.0 --port=8888 --no-browser"]
