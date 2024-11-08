FROM python:3.12.4-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY sistema_neuverse /sistema_neuverse
COPY scripts /scripts
COPY requirements.txt /sistema_neuverse/

WORKDIR /sistema_neuverse

EXPOSE 8000

RUN python -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install --default-timeout=100 -r /sistema_neuverse/requirements.txt && \
    adduser --disabled-password --no-create-home server && \
    mkdir -p /data/web/static && \
    mkdir -p /data/web/media && \
    chown -R server:server /venv && \
    chown -R server:server /data/web/static && \
    chown -R server:server /data/web/media && \
    chmod -R 755 /data/web/static && \
    chmod -R 755 /data/web/media && \
    chmod -R +x /scripts && \
    chmod -R +x /scripts/collectstatic.sh && \
    chmod -R +x /scripts/migrate.sh && \
    chmod -R +x /scripts/makemigrations.sh && \
    chmod -R +x /scripts/runserver.sh && \
    chmod -R +x /scripts/commands.sh

ENV PATH="/scripts:/venv/bin:$PATH"

USER server

CMD ["bash", "/scripts/commands.sh"]

