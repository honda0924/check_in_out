# 環境構築

## Dockerfile作成

```Dockerfile
FROM ruby:2.5.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /check_in_out
ENV APP_ROOT /check_in_out
WORKDIR $APP_ROOT

ADD Gemfile $APP_ROOT/Gemfile
ADD Gemfile.lock $APP_ROOT/Gemfile.lock

RUN bundle install


ADD . $APP_ROOT
```

## Gemfile作成

``` Gemfile
source 'https://rubygems.org'
gem 'rails', '5.2.2'
```

## 空のGemfile.lockを作成

## docker-compose.yml作成

```yml
version: '3'
services:
  db:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: root
    ports:
      - "3306:3306"

  web:
    build: .
    command: rails s -p 3000 -b '0.0.0.0'
    volumes:
      - .:/check_in_out
    ports:
      - "3000:3000"
    links:
      - db
```

## rails newを実行

``` terminal
docker-compose run web rails new . --force --database=mysql --skip-bundle
```

## database.yml修正

```yml
default: &default
  adapter: mysql2
  encoding: utf8
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: root
  password: password
  host: db
```

## Docker起動

```terminal
docker-compose build
docker-compose up -d
```

## DB作成

```terminal
docker-compose run web rails db:create
```

## local環境ブラウザ確認

http://localhost:3000

#　ユーティリティ

## コンテナ停止

```terminal
docker-compose down
```

## Docker関連ファイルの変更反映してRailsサーバ再起動

```terminal
docker-compose up --build
```

## bundle install

```terminal
docker-compose run web bundle install
```

## MySQLコンテナ接続

```terminal
mysql -u root -p -h localhost -P 3306 --protocol=tcp
```
