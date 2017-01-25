FROM ruby:2.3.1-slim

ENV RAILS_ROOT=/usr/app/dockerized-rails
ENV RAILS_ENV=production

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client libproj-dev nodejs

RUN mkdir -p $RAILS_ROOT/tmp/pids
WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle check || bundle install --without development test -j4

COPY config/puma.rb config/puma.rb

COPY . .

# VOLUME ["$RAILS_ROOT/public"]

RUN DB_ADAPTER=nulldb bundle exec rake assets:precompile RAILS_ENV=production --trace

EXPOSE 3000
