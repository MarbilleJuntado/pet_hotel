FROM elixir:1.11-alpine

ARG app_name=pet_hotel
ARG phoenix_subdir=.
ARG build_env=prod
ENV MIX_ENV=${build_env} TERM=xterm

RUN apk update \
  && mix local.rebar --force \
  && mix local.hex --force

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN mix do deps.get, compile, phx.digest
RUN mix release ${app_name} \
  && mv _build/${build_env}/rel/${app_name} /opt/release \
  && mv /opt/release/bin/${app_name} /opt/release/bin/start_server

# Runtime container
FROM alpine:latest
RUN apk update \
  && apk --no-cache --update add bash ca-certificates openssl-dev \
  && mkdir -p /usr/local/bin

ENV REPLACE_OS_VARS=true

# For local dev, heroku will ignore this
EXPOSE $PORT

WORKDIR /opt/app
COPY --from=0 /opt/release .
RUN addgroup -S elixir && adduser -H -D -S -G elixir elixir
RUN chown -R elixir:elixir /opt/app
USER elixir

# Heroku sets magical $PORT variable
CMD PORT=$PORT exec /opt/app/bin/start_server start
