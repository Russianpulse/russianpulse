FROM ruby:2.3.1

MAINTAINER Sergei O. Udalov <sergei.udalov@gmail.com>

ENV HOME /root

RUN apt-get update -qq && apt-get install -y --force-yes build-essential \
  # Postgres \
  libpq-dev \
  # Nokogiri \
  libxml2-dev libxslt1-dev nodejs

RUN mkdir -p /app
WORKDIR /app

ADD Gemfile* ./
RUN bundle install

ADD . ./

RUN mkdir -p tmp/pids

EXPOSE 80

CMD ["./bin/web"]
