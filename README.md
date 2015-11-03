# Rails JWT (JSON Web Token) Example

This Rails example demonstrates how to use [JWT](http://jwt.io/) for authentication.

# Setup

Clone the repo
```sh
git clone https://github.com/dibenso/rails-jwt-example
```

Install gem dependencies
```sh
bundle install
```

Run db migrations
```sh
rake db:migrate
```

Start the server
```sh
rails s
```

# Testing out the routes
There are 3 routes that can be used for testing registration and authentication
  - POST /employers/register
  - POST /employers/sign_in
  - GET /employers/index

These routes request and respond with JSON

To register a new user:
```sh
curl -H "Content-Type: application/json" --data '{"email": "email@example.com", "username": "username1", "password": "password123"}' 127.0.0.1:3000/employers/register
```

responds with something like:
```sh
{"id":1,"email":"email@example.com","username":"username1","created_at":"2015-11-03T17:35:55.670Z","updated_at":"2015-11-03T17:35:55.670Z","registration_token":"369455df-8660-4117-aeb9-c6e29d880b4c","token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0NDY1ODY1NTUsImlkIjoxfQ.IjEhLJ07ONhRBfFaYnmcCoGjZmqCFHNtUBfLm0fKDTA"}
```

Sign in with that user:
```sh
curl -H "Content-Type: application/json" --data '{"email": "email@example.com", "password": "password123"}' 127.0.0.1:3000/employers/sign_in
```

responds with something like:
```sh
{"id":1,"email":"email@example.com","username":"username1","created_at":"2015-11-03T17:35:55.670Z","updated_at":"2015-11-03T17:35:55.670Z","registration_token":"369455df-8660-4117-aeb9-c6e29d880b4c","token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0NDY1ODY2MzMsImlkIjoxfQ.KOsL1coYvQUdfVr1n3y85KEUnmB2T8jl2REBb3vFE84"}
```

To authenticate using the token from the previous response pass it in as an Authorization header like:
```sh
curl -H "Authorization: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0NDY1ODY2MzMsImlkIjoxfQ.KOsL1coYvQUdfVr1n3y85KEUnmB2T8jl2REBb3vFE84" 127.0.0.1:3000/employers/index
```

You should then get a response like:
```sh
{"id":1,"email":"email@example.com","username":"username1","created_at":"2015-11-03T17:35:55.670Z","updated_at":"2015-11-03T17:35:55.670Z","registration_token":"369455df-8660-4117-aeb9-c6e29d880b4c"}
```
