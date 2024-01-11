FROM python:slim-buster

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y iputils-ping

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
ENV TZ="Europe/Bratislava"
ENV SENDTOAPI=1

COPY . .

CMD [ "python", "udplisteningbeacons.py" ]