FROM python:3.10

WORKDIR /code
COPY requirements.txt /requirements.txt

RUN pip install -r requirements.txt

RUN useradd -m -u 1000 user
USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH \
    AUTOGENSTUDIO_APPDIR=/home/user/app

WORKDIR $HOME/app

COPY --chown=user . $HOME/app

CMD gunicorn -w $((2 * $(getconf _NPROCESSORS_ONLN) + 1)) --timeout 12600 -k uvicorn.workers.UvicornWorker autogenstudio.web.app:app --bind "0.0.0.0:8081"
