# syntax=docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=3.4.1
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Set working directory and install base packages for Rails
WORKDIR /rails
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment variables
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Copy your startup script and set permissions
#COPY start_servers.sh /rails/start_servers.sh


# Build stage: install build tools and gems
FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy gem files and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy all application files (including the submodule pointer)
COPY . .
RUN chmod +x /rails/start_servers.sh

# Initialize (or update) the submodules so that /rails/passiogo is populated
RUN git clone --recurse-submodules https://github.com/dayne-2stacks/passiogo.git

#RUN git submodule update --init --recursive

# Precompile bootsnap code and assets
RUN bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final image stage
FROM base

# Install Python, pip, and the venv module as root
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y python3 python3-pip python3-venv && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems and application code
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# (If not already created, you can create the non-root user here)
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /rails

# Create the virtual environment and install FastAPI (Passiogo) dependencies
WORKDIR /rails/passiogo
RUN python3 -m venv /rails/venv && \
    /rails/venv/bin/pip install --no-cache-dir -r requirements.txt

# Ensure the virtual environment is used for all Python commands
ENV PATH="/rails/venv/bin:$PATH"

# Switch to the non-root user for security
USER 1000:1000

WORKDIR /rails



# Entrypoint and default command
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 80 8080
CMD ["/rails/start_servers.sh"]
