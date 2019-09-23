FROM ruby:2.6.4-alpine
WORKDIR /usr/src/app
RUN apk --update --no-cache add --virtual build-dependencies ruby-dev build-base
COPY Gemfile Gemfile.lock ./
RUN gem install --no-document bundler && bundle install --jobs=$(nproc) && apk del build-dependencies
COPY . .
EXPOSE 4567
CMD ["bundle", "exec", "ruby", "app.rb", "-e production"]
