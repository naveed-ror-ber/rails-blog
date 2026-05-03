FROM ruby:3.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set an environment variable for the app directory
ENV RAILS_ROOT /usr/src/app

# Create a new directory for the app
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

# Installing gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Add application code
COPY . .

# Run the entrypoint script
CMD ["./entrypoint.sh"]