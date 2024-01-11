FROM python:slim-buster

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
ENV TZ="Europe/Bratislava"

COPY . .

CMD [ "python", "./ntpserver.py" ]