FROM python:3.9-slim-buster

WORKDIR /app

RUN pip install flask psycopg2-binary bcrypt

CMD ["python", "/app/db-bridge.py"]