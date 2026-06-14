FROM ruby:4.0.2-alpine

RUN apk add build-base curl
RUN bundle config --global frozen 1
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle config --global frozen 1
RUN bundle config --global without 'development test'
RUN bundle install
COPY . .

EXPOSE 3000
ENV RACK_ENV=production
CMD ["/usr/local/bin/bundle", "exec", "puma", "-b", "tcp://0.0.0.0:3000"]
HEALTHCHECK --start-period=1s --start-interval=1s \
  CMD curl -f http://localhost:3000/healthcheck || exit 1

