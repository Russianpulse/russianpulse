FROM debian:jessie

RUN apt-get update && apt-get install -y \
  cron \
  postgresql-client \
  duplicity \
  ncftp

RUN mkdir /backup
RUN touch /var/log/backup.log
ADD ./backup.sh /etc/cron.daily/
RUN chmod +x /etc/cron.daily/backup.sh

CMD tail -f /var/log/backup.log
