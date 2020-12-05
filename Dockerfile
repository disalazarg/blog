FROM elixir:1.10.4-alpine AS build

RUN mkdir -p /app
WORKDIR /app

ENV MIX_ENV=prod HEX_HTTP_TIMEOUT=240

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock ./
COPY apps/blog/mix.exs apps/blog/mix.exs
COPY apps/blog_web/mix.exs apps/blog_web/mix.exs
COPY config config

RUN mix deps.get
RUN mix deps.compile

COPY apps apps
RUN mix compile

COPY rel rel
RUN mix release

# Runtime
FROM alpine:3.12

RUN apk add --update \
        bash \
        openssl \
        curl \
        libc6-compat \
        libpthread-stubs

RUN mkdir -p /app
WORKDIR /app

COPY --from=build /app/_build/prod/rel/blog ./

ENV HOME=/app PORT=4000 PATH="/app:/app/bin:${PATH}"

EXPOSE 4000

CMD ["blog", "start"]