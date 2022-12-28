#!/bin/bash

# Exit on fail
set -e

if [ -f tmp/pids/server.pid ]; then
  rm -f tmp/pids/server.pid
fi

./bin/inject_port_into_nginx.sh

nginx -c /etc/nginx/conf.d/default.conf

# Run pending migrations (if any) and start rails
bundle exec rails db:migrate
bundle exec rails s -p 3000 -b 0.0.0.0
