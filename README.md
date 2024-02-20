first - docker-compose build


second - start GRAM




Request: 

1. register user - [POST] - http://localhost:8080/user

Body request:
  login: String,
  email: String,
  password: String,
  name: String,
  age: Int


2. get all users - [GET] - http://localhost:8080/user/all
3. authorization user - http://localhost:8080/user/auth
body: login:String, password:String











