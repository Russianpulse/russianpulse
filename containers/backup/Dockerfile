FROM renskiy/cron

RUN apt-get update && apt-get install -y \
  postgresql-client \
  duplicity \
  ncftp \
  curl

RUN mkdir /backup
RUN mkdir /restore

ADD ./bin/backup /bin/backup
ADD ./bin/restore /bin/restore
ADD ./bin/start-the-cron /bin/start-the-cron
RUN chmod +x /bin/backup
RUN chmod +x /bin/restore
RUN chmod +x /bin/start-the-cron

CMD ["start-the-cron"]
