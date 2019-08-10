FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /mapAPI
WORKDIR /mapAPI
COPY Gemfile /mapAPI/Gemfile
COPY Gemfile.lock /mapAPI/Gemfile.lock
RUN gem install gel && gel install
COPY . /mapAPI

EXPOSE 3000

CMD [ "bundle", "exec", "puma", "-C", "config/puma.rb" ]