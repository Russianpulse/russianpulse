FROM registry.gitlab.com/sergio-fry/mazavr-engine:base

ADD Gemfile* ./
RUN bundle install

ADD . ./

RUN mkdir -p tmp/pids

EXPOSE 3000

CMD ["./bin/web"]
