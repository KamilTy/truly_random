#!/bin/bash
set -e

bundle exec rake db:create RAILS_ENV=development
bundle exec rake db:migrate RAILS_ENV=development
bundle exec rake db:seed RAILS_ENV=development

exec "$@"
