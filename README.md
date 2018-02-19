# Google Map API Distance Calculator

**System Specification**

* Language: Ruby 2.5.0
* Framework: Rails 5.1.5
* Database: Postgres 10
* Cache DB: Redis 4.0.0
* Background Processor: Sidekiq 5.1.1

This system has two components:

* An endpoint recevies a list of traveling points (POST /route) and it returns a token. It will pass the communication with Google Map API to the background processor (Sidekiq).
* An endpoint recevies a token (GET /route/:token) and it returns the path traveling through all the locations and shortest driving distance and time.

**System Setup and Configuration**

For the first time usage, please run the database migration. 

```
$ docker-compose build
$ docker-compose run app rails db:create # first time use, create db 
$ docker-compose run app rails db:migrate # first time use, create respective tables
$ docker-compose up --scale app=2 # where the number can be configured as needed
```

**Key files in the System**

```
app/controllers/route_controller.rb
app/decorators/routing_info_decorator.rb
app/jobs/*
app/models/*
app/views/route/*
spec/models/*
```

**Unit Testing**
I wrote some test cases for understanding the data validations. You can run the following command and check the files under `spec/`
```
docker-compose run app rspec -f d
```

**Baseurl** 
http://localhost:8080