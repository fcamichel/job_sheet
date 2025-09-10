FROM elixir:1.15-alpine AS build

# Install build dependencies
RUN apk add --no-cache build-base git python3 curl nodejs npm

# Prepare build dir
WORKDIR /app

# Install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set build ENV
ENV MIX_ENV=prod

# Install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# Copy compile-time config
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

# Copy application files
COPY priv priv
COPY lib lib
COPY assets assets

# Compile assets
RUN mix assets.deploy

# Compile the release
RUN mix compile

# Build release
RUN mix release

# Start a new build stage for the runtime
FROM alpine:3.18 AS runtime

RUN apk add --no-cache openssl ncurses-libs libstdc++ libgcc

WORKDIR /app

# Create a non-root user
RUN adduser -D -h /app app
USER app

# Copy the release from the build stage
COPY --from=build --chown=app:app /app/_build/prod/rel/job_sheet ./

ENV HOME=/app
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=placeholder
ENV DATABASE_URL=placeholder

EXPOSE 4000

CMD ["bin/job_sheet", "start"]
