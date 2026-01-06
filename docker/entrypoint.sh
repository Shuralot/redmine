#!/bin/bash
set -e

# Espera o banco (opcional mas recomendado)
if [ -n "$DATABASE_URL" ]; then
  echo "Database configured via DATABASE_URL"
fi

# Cria database.yml se não existir
if [ ! -f config/database.yml ]; then
  echo "Creating database.yml from example"
  cp config/database.yml.example config/database.yml
fi

# Assets
echo "Precompiling assets..."
bundle exec rake assets:precompile

# Migrações
echo "Running migrations..."
bundle exec rake db:migrate

exec "$@"
