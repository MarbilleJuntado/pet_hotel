#!/bin/sh
set -e # exit on error
# put ids on .env which docker-compose reads
printf "USER_ID=$(id -u ${USER})\nGROUP_ID=$(id -g ${USER})" > .env
docker-compose build
docker-compose run api mix do deps.get, deps.compile, ecto.setup
