FROM ruby:2.6
# установка библиотек для работы приложения (сейчас отсутствуют)
RUN apt-get update -qq && apt-get install -y locales

# установка локали, чтобы испльзовать русский в консоли внутри контейнера
RUN echo "ru_RU.UTF-8 UTF-8" > /etc/locale.gen && \
  locale-gen ru_RU.UTF-8 && \
  /usr/sbin/update-locale LANG=ru_RU.UTF-8
ENV LC_ALL ru_RU.UTF-8

WORKDIR /app
COPY Gemfile* ./
RUN bundle install
# сообщаем другим разработчикам и devopsам о том, на каком порту работает наше приложение
EXPOSE 3000


FROM development as production
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true
ENV SECRET_KEY_BASE=67186287few61287
COPY . .
RUN DATABASE_URL=postgresql://user:password@db:5432/development rails assets:precompile
CMD puma -t 3:5 -w 2 -b tcp://0.0.0.0:3000
