# Use official Ruby image
FROM ruby:3.2

# Set environment variables
ENV REDIS_URL=redis://redis:6379/0

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  nodejs \
  yarn \
  sqlite3 \
  && rm -rf /var/lib/apt/lists/*

# Set up the working directory
WORKDIR /myapp

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application files
COPY . .

# Set permissions for /tmp directory
RUN chmod 777 /tmp

# Expose port 3000 for Rails
EXPOSE 3000

# Set the default command to run the Rails server
CMD ["sh", "-c", "rails db:prepare && rails s -b 0.0.0.0 & bundle exec sidekiq"]
