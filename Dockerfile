FROM ruby:2.6-slim
MAINTAINER Sergei O. Udalov <sergei.udalov@gmail.com>
WORKDIR /app

RUN apt-get update -qq && apt-get install -y libxml2-dev libxslt1-dev \
      libsqlite3-dev libpq-dev gnupg \
      build-essential curl libfontconfig wget

RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 -O /tmp/phantom.tar.bz2 \
      && cd /tmp && tar -xvf phantom.tar.bz2 && mv phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update -qq && apt-get install -y nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn

ADD Gemfile* ./
RUN bundle install -j $(nproc) --path /vendor
ADD package.json yarn.lock ./
RUN yarn install 

ADD . ./

ENV RAILS_ENV=production
ENV DATABASE_URL=sqlite3:///db/production.sqlite3
ENV SECRET_KEY_BASE=abc123
RUN bundle exec rake assets:precompile

ENV MALLOC_ARENA_MAX=2

VOLUME /app/public/yandex
EXPOSE 80
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["web"]
