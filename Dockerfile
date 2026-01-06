FROM ruby:3.2-slim

# Dependências do sistema
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libmariadb-dev \
    libsqlite3-dev \
    libyaml-dev \
    git \
    imagemagick \
    ca-certificates \
    curl \
    tzdata \
    bash \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/redmine

# Código
COPY . .

# Bundler
RUN gem install bundler
RUN bundle install --jobs 4 --retry 3

EXPOSE 3000

ENTRYPOINT ["bash", "docker/entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]
