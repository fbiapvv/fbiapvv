FROM python:3.10.4
LABEL key="django_becotrack"

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	mariadb-client \
	iputils-ping \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY requirements.txt ./
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN pip install pytz
COPY . .

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]