FROM ruby:3.1.2

ENV THREADS=
ENV WORKERS=

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without test development
RUN bundle install

COPY . .

EXPOSE 3001

CMD ["iodine", "-p", "3001"]
