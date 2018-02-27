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
RUN bundle install --deployment --without development test

ADD . ./

ENV RAILS_ENV=production
ENV DATABASE_URL=sqlite3:///db/production.sqlite3
ENV SECRET_KEY_BASE=abc123
RUN rake assets:precompile

EXPOSE 80

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["web"]
