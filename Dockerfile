# This Dockerfile is designed for production, not development.
# docker build -t app .
# docker run -d -p 80:80 8080:8080 -e RAILS_MASTER_KEY=8e133a9f3cce8d307ffd41360867837d --name app app

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.1
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
# Replace libpq-dev with sqlite3 if using SQLite, or libmysqlclient-dev if using MySQL
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips libpq-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential curl git pkg-config libyaml-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install JavaScript dependencies and Node.js for asset compilation
#
# Uncomment the following lines if you are using NodeJS need to compile assets
#
 ARG NODE_VERSION=22.14.0
 ARG YARN_VERSION=1.22.22
 ENV PATH=/usr/local/node/bin:$PATH
 RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
     /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
     npm install -g yarn@$YARN_VERSION && \
     npm install -g mjml && \
     rm -rf /tmp/node-build-master

# Install Python, pip, and venv (for Passiogo)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y python3 python3-pip python3-venv && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Install node modules
#
# Uncomment the following lines if you are using NodeJS need to compile assets
#
 COPY package.json yarn.lock ./
 RUN --mount=type=cache,id=yarn,target=/rails/.cache/yarn YARN_CACHE_FOLDER=/rails/.cache/yarn \
     yarn install --frozen-lockfile


# Copy application code
COPY . .

RUN yarn build:css
RUN yarn build

## Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/
#
## Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Initialize (or update) the passiogo-api submodule if not already present
RUN if [ ! -d "/rails/passiogo-api" ]; then \
      git clone --recurse-submodules https://github.com/dayne-2stacks/passiogo-api.git /rails/passiogo-api; \
    else \
      echo "passiogo-api already exists"; \
    fi

# Set up the Python virtual environment in passiogo-api
WORKDIR /rails/passiogo-api
RUN python3 -m venv /rails/venv && \
    chown -R 1000:1000 /rails/venv
# Uncomment the following if you have a requirements.txt:
RUN /rails/venv/bin/pip install --no-cache-dir -r requirements.txt

# Ensure the virtual environment is used
ENV PATH="/rails/venv/bin:$PATH"

WORKDIR /rails

# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

RUN apt-get update -qq && apt-get install --no-install-recommends -y python3 && \
    rm -rf /var/lib/apt/lists/*

ARG NODE_VERSION=22.14.0
ARG YARN_VERSION=1.22.22
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
     /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
     npm install -g yarn@$YARN_VERSION && \
     npm install -g mjml && \
     rm -rf /tmp/node-build-master


ENV PATH="/rails/venv/bin:$PATH"


RUN chmod +x bin/run /rails/venv/bin/activate bin/prod
RUN chmod -R +x /rails/app/assets/


# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db storage tmp passiogo-api bin/run /rails/venv/bin/activate /rails/app/assets/ bin/prod
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]



EXPOSE 3000 8080
CMD ["/rails/bin/run"]

