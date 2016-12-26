FROM registry.gitlab.com/russianpulse/mazavr:base

MAINTAINER Sergei O. Udalov <sergei.udalov@gmail.com>

RUN mkdir -p /app
WORKDIR /app

ADD Gemfile* ./
RUN bundle install

ADD . ./

RUN mkdir -p tmp/pids

EXPOSE 3000

CMD ["./bin/web"]
