FROM ruby:3.1.1-alpine
RUN apk add \
    build-base \
    postgresql-dev \
    tzdata \
    nodejs
WORKDIR /geolocation_api
COPY Gemfile* .
RUN bundle install
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]