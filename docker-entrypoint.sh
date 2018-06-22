#!/bin/bash
set -e

if [ "$1" = 'update' ]; then
  bundle exec rake db:migrate
  exit 0
fi

if [ "$1" = 'worker' ]; then
  rm -rf tmp/pids/*
  bundle exec sidekiq -C config/sidekiq.yml
fi

if [ "$1" = 'web' ]; then
  rm -rf tmp/pids/*
  bundle exec rake db:migrate
  bundle exec rails server puma -p 80 --binding 0.0.0.0
fi

if [ "$1" = 'server' ]; then
  rm -rf tmp/pids/*
  bundle exec rails server puma -p 80 --binding 0.0.0.0
fi

if [ "$1" = 'spec' ]; then
  echo 'Specs...'
  export RAILS_ENV=test
  bundle exec rake db:create db:migrate
  bundle exec rspec
  exit 0
fi

exec "$@"
