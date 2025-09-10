#!/usr/bin/env bash
# exit on error
set -o errexit

# Install hex and rebar
mix local.hex --force
mix local.rebar --force

# Install dependencies
mix deps.get --only prod

# Compile the project
MIX_ENV=prod mix compile

# Build assets
MIX_ENV=prod mix assets.deploy

# Run migrations
MIX_ENV=prod mix ecto.migrate

# If needed, seed the database
# MIX_ENV=prod mix run priv/repo/seeds.exs
