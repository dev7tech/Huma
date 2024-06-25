FROM python:3.12.2


RUN mkdir -p /app/models

WORKDIR /app



COPY aicharactermulti.py aiConversationManager.py Modelfile2 requirements.txt start.sh /app

COPY .env .env




RUN apt-get update && \
    apt-get install -y lshw

RUN pip install -r requirements.txt

RUN curl -fsSL https://ollama.com/install.sh | sh

CMD ["./start.sh"]
