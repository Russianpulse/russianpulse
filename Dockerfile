FROM phusion/passenger-ruby23

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

RUN mkdir /home/app/mazavr
WORKDIR /home/app/mazavr

# Base gems layer
ADD .gemfiles_base/Gemfile* ./
RUN bundle install

# build bundle first to install all gems 
# on each code update
ADD Gemfile* ./
RUN bundle install

ADD . ./
RUN mkdir -p tmp/pids

# NOTE: disabled because of bad production config
RUN bundle exec rake assets:precompile

RUN chown -R app: log

RUN rm /etc/nginx/sites-enabled/default
ADD config/passenger_app.conf /etc/nginx/sites-enabled/mazavr.conf
ADD config/passenger_env.conf /etc/nginx/main.d/mazavr_env.conf

##############################################################################
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /etc/service/nginx/down

EXPOSE 3000

CMD ["./bin/web"]
