# README

## Ruby version
2.30

## Setup your local env:
1. run `bundle install`
2. run `docker-machine create --driver virtualbox shotgun-api`
3. run `docker-machine env shotgun-api`
4. run `eval $(docker-machine env shotgun-api)`
5. run `docker-compose up -d`
6. run `bundle exec rake db:create`
7. run `bundle exec rake db:migrate`
