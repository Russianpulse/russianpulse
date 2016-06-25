FROM busybox:glibc

RUN mkdir -p /var/spool/cron/crontabs

ADD ./crontab /var/spool/cron/crontabs/root

CMD crond -f
