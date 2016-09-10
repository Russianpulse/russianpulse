FROM ruby:2.3.1

MAINTAINER Sergei O. Udalov <sergei.udalov@gmail.com>

# Set correct environment variables.
ENV HOME /root

##############################################################################
# APP install

RUN apt-get update -qq && apt-get install -y build-essential \
  # Postgres \
  libpq-dev \
  # Nokogiri \
  libxml2-dev libxslt1-dev nodejs

RUN gem install bundler -v '1.12.5' && \
    gem install bundler-audit -v '0.5.0' && \
    gem install rubocop -v '0.41.2'

RUN mkdir -p /app
WORKDIR /app

# Base gems layer
ADD .gemfiles_base/Gemfile* ./
RUN bundle install

# build bundle first to install all gems
# on each code update
ADD Gemfile* ./
RUN bundle install

ADD . ./

RUN mkdir -p tmp/pids

EXPOSE 3000

CMD ["./bin/web"]
