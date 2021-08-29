# Pet Hotel

## Installation
```
docker-compose build
docker-compose run api mix do deps.get, deps.compile, ecto.setup
```

## Run (in development)
```
docker-compose up
```
or
```
docker-compose run api
```

## Test (in development)
```
docker-compose run test
```
