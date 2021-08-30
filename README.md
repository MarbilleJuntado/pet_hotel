# Pet Hotel

## Installation
```
docker-compose build
docker-compose run api mix do deps.get, deps.compile, ecto.setup
```

## Run
```
docker-compose up
```
or
```
docker-compose run api
```
### Sample requests
Get list of pets: 
```
curl http://localhost:4000/api/pet
```
Create a new pet owner:
```
curl -XPOST -H "Content-type: application/json" -d '{"pet_owner": {"name": "jane", "email": "jane@example.com"}}' 'http://localhost:4000/api/pet-owner'
```
### Live Demo
[Link](https://pet-hotel-2021.herokuapp.com/swaggerui)

Usage:
```
curl https://pet-hotel-2021.herokuapp.com/api/pet-owner
```
## Test (in development)
```
docker-compose run test
```
