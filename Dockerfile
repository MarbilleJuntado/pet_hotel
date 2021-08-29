FROM bitwalker/alpine-elixir-phoenix:latest

ARG USER_ID
ARG GROUP_ID

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

CMD mix deps.get && mix phx.server
