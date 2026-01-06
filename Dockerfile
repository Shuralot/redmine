FROM ruby:3.2-slim

ENV RAILS_ENV=production \
    REDMINE_HOME=/usr/src/redmine

# Dependências do sistema (Debian moderno)
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libmariadb-dev \
    libsqlite3-dev \
    git \
    imagemagick \
    ca-certificates \
    curl \
    tzdata \
    bash \
    && rm -rf /var/lib/apt/lists/*

WORKDIR $REDMINE_HOME

# Copia TODO o fork
COPY . .

# Bundler
RUN gem install bundler

# Gems
RUN bundle config set without 'development test' \
    && bundle install --jobs 4 --retry 3

# Assets
RUN bundle exec rake assets:precompile

# Entrypoint
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-C", "docker/puma.rb"]
