FROM python:3.9.7-slim-buster

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update \
    && apt-get install -y curl \
    && curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python -

ENV PATH="${PATH}:/root/.local/bin"

WORKDIR /app

COPY . /app/

RUN poetry config virtualenvs.create false \
    && poetry install \
    && poetry run python manage.py makemigrations \
    && poetry run python manage.py migrate
EXPOSE 80
CMD ["poetry", "run", "python", "manage.py", "runserver", "0.0.0.0:80"]
