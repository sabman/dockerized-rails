

APP_NAME=dockerized-rails

cd $APP_NAME

# Before we start we will make sure that we have a scafolled app just to make sure we can test everything is working
docker-compose up
docker-compose run app bundle exec rails generate scaffold post title body:text published:boolean
docker-compose run app bundle exec rake db:migrate

# We can also make sure the development test works:

docker-compose run app bundle exec rake db:setup RAILS_ENV=test
docker-compose run app bundle exec rake test RAILS_ENV=test

RAILS_ENV=production
mkdir -p containers/$RAILS_ENV

# Add nulldb gem to allow creating assets without a db connection
# read: http://blog.zeit.io/use-a-fake-db-adapter-to-play-nice-with-rails-assets-precompilation/"

echo "gem 'activerecord-nulldb-adapter'" >> Gemfile

# create Dockerfile
cat > containers/$RAILS_ENV/Dockerfile <<EOF
FROM ruby:2.3.1-slim

ENV RAILS_ROOT=/usr/app/${APP_NAME}
ENV RAILS_ENV=production

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client libproj-dev nodejs

RUN mkdir -p \$RAILS_ROOT/tmp/pids
WORKDIR \$RAILS_ROOT

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle check || bundle install --without development test -j4

COPY config/puma.rb config/puma.rb

COPY . .

RUN DB_ADAPTER=nulldb bundle exec rake assets:precompile RAILS_ENV=production --trace

EXPOSE 3000

EOF
