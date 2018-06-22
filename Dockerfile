# Assets
FROM ruby:2.3-slim as bundle
WORKDIR /app
RUN apt-get update -qq && apt-get install -y libxml2-dev libxslt1-dev libsqlite3-dev libpq-dev
RUN apt-get update -qq && apt-get install -y build-essential curl gnupg
ENV RAILS_ENV=production
ENV DATABASE_URL=sqlite3:///db/production.sqlite3
ENV SECRET_KEY_BASE=abc123
ADD Gemfile* ./
RUN bundle install --deployment --without development test -j $(nproc) --path /vendor
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update -qq && apt-get install -y nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn
ADD package.json yarn.lock ./
RUN yarn install 
ADD . ./
RUN bundle exec rake assets:precompile

# Application
FROM ruby:2.3-slim
WORKDIR /app
RUN apt-get update -qq && apt-get install -y libxml2-dev libxslt1-dev libsqlite3-dev libpq-dev
RUN apt-get update -qq && apt-get install -y build-essential curl gnupg
MAINTAINER Sergei O. Udalov <sergei.udalov@gmail.com>
ENV HOME /root
ENV RAILS_ENV=production
COPY --from=bundle /vendor /vendor
ADD Gemfile* ./
RUN bundle install --deployment --without development test -j $(nproc) --path /vendor
COPY --from=bundle /app/public/assets ./public/
ADD . ./
VOLUME /app/public/yandex
EXPOSE 80
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["web"]
