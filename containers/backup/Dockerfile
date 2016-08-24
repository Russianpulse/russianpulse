FROM debian:jessie

RUN apt-get update && apt-get install -y \
  cron \
  postgresql-client \
  duplicity \
  ncftp \
  curl

RUN mkdir /backup
RUN mkdir /restore

RUN touch /var/log/backup.log
ADD crontab /etc/crontab

ADD ./bin/backup /bin/backup
ADD ./bin/restore /bin/restore

CMD cron && tail -f /var/log/backup.log
