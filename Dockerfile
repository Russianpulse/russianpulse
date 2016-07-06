FROM ruby:2.3.1
MAINTAINER Sergei O. Udalov <sergei.udalov@gmail.com>

RUN apt-get update -qq && apt-get install -y build-essential \
  # Postgres \
  libpq-dev \
  # Nokogiri \
  libxml2-dev libxslt1-dev nodejs

RUN gem install bundler

WORKDIR /app

# build bundle first to install all gems 
# on each code update
ADD Gemfile* /app/
RUN bundle install

ADD . /app

RUN bundle exec rake assets:precompile

VOLUME /app/public/sitemaps/

EXPOSE 3000
CMD bin/run
