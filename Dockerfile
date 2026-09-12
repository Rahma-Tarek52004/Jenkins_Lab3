FROM python:3.12-slim

WORKDIR /app

COPY hello.py .

RUN pip install --no-cache-dir flask

EXPOSE 5000

CMD ["python", "hello.py"]