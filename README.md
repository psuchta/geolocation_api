# README

## Project Setup
  - Project was build based on Docker images.
    It should be enough to just simple run:
      1. ```docker-compose up -d```
      2. ```docker-compose run app bundle exec rake db:setup```

# Endpoints
  Endpoints that are available in the application:
  ```
    - GET    /api/v1/ip_infos  - Returns geolocation data for requested ip/url
    - POST   /api/v1/ip_infos  - Creates geolocation data for requested ip/url. If ip/url is already in the database geolocation data will be updated.
    - DELETE /api/v1/ip_infos -  Deletes geolocation data from the database for requested ip/url
  ```

## Endpoints parameters
  Each of the endpoints can receive 2 parameters.  
  Client shouldn't send two parameters to the endpoint on the same time. `Ip` always has higher priority. 

  `ip` - Ip address || Examples: `8.8.8.8`, `2001:db8:3333:4444:5555:6666:7777:8888`

  `url`- Url of the website || Examples: `www.wp.pl`, `wp.pl`, `www.wp.pl/asd/asd`, `http://www.wp.pl`

# REST API

The REST API to the example app is described below.

## Get Geolocation data

### Request

`GET /api/v1/ip_infos`

    curl --location --request GET 'localhost:3000/api/v1/ip_infos' --form 'ip="8.8.8.8"'

### Response

    {
        "data": {
            "id": 2,
            "ip": "8.8.8.8",
            "url": null,
            "ip_type": "ipv4",
            "continent_name": "North America",
            "country_name": "United States",
            "region_name": "Ohio",
            "city": "Glenmont",
            "zip": "44628",
            "latitude": "40.5369987487793",
            "longitude": "-82.12859344482422",
            "created_at": "2023-10-20T10:07:13.539Z",
            "updated_at": "2023-10-20T10:07:13.539Z"
        }
    }

## Create/Update goelocation entry

### Request

`POST /api/v1/ip_infos`

    curl --location 'localhost:3000/api/v1/ip_infos' --form 'ip="8.8.8.8"'

### Response

    {
    "data": {
        "updated_at": "2023-10-20T10:05:46.983Z",
        "id": 1,
        "ip": "212.77.98.9",
        "url": "wp.pl",
        "ip_type": "ipv4",
        "continent_name": "Europe",
        "country_name": "Poland",
        "region_name": "Pomerania",
        "city": "Gdańsk",
        "zip": "80-009",
        "latitude": "54.31930923461914",
        "longitude": "18.63736915588379",
        "created_at": "2023-10-20T09:58:38.050Z"
      }
    }

## Delete goelocation entry

### Request

`DELETE /api/v1/ip_infos`

    curl --location --request DELETE 'localhost:3000/api/v1/ip_infos' --form 'ip="8.8.8.8"'

### Response

    {
        "message": "Destroyed successfully",
        "data": 2
    }

