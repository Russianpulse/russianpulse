FROM ruby:2.2.3
MAINTAINER Sergei O. Udalov <sergei.udalov@gmail.com>

RUN apt-get update -qq && apt-get install -y build-essential \
  # Postgres \
  libpq-dev \
  # Nokogiri \
  libxml2-dev libxslt1-dev nodejs

WORKDIR /app


# build bundle first to install all gems 
# on each code update
ADD Gemfile* /app/
RUN bundle install

ADD . /app

CMD bundle exec rails server --binding 0.0.0.0 --port 3000
