FROM ruby:3.1.1
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /geolocation_api
COPY Gemfile /geolocation_api/Gemfile
COPY Gemfile.lock /geolocation_api/Gemfile.lock
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]