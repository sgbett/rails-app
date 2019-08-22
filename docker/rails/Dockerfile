# docker run -it rails-app /bin/bash

FROM ruby:2.4

WORKDIR /tmp

RUN apt-get update
RUN apt-get install -y nodejs --no-install-recommends
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*

WORKDIR /rails-app

COPY Gemfile .
COPY Gemfile.lock .

RUN gem install bundler --version '~> 1.0'
RUN bundle config --global frozen 1
RUN bundle install
