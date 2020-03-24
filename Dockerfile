FROM python:3.7.7-slim-stretch

COPY app/ /app/
COPY tests/ /tests/
COPY requirements.txt /

WORKDIR /app

# hadolint ignore=DL3013
RUN pip install --upgrade pip &&\
    pip install --trusted-host pypi.python.org -r /requirements.txt

EXPOSE 5000

CMD ["python", "app.py"]
