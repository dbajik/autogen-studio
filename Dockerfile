FROM python:3.10

WORKDIR /code
RUN pip install -U gunicorn autogenstudio

RUN useradd -m -u 1000 user
USER root
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH \
    AUTOGENSTUDIO_APPDIR=/home/user/app
WORKDIR $HOME/app

COPY --chown=user . $HOME/app

# Ajustar los permisos antes de cambiar al usuario "user"
RUN chown -R user:user $HOME/app

USER user

CMD autogenstudio ui --port $PORT --database-uri postgresql+psycopg://postgres:infobae2024@10.39.32.3:5432/autogen
