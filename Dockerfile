FROM ruby:3.1.2
WORKDIR /app
COPY Gemfile .
RUN bundle
COPY . .
EXPOSE 3000
CMD ["./bin/rails", "s", "-b", "0.0.0.0"]