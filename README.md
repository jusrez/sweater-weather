![](https://img.shields.io/badge/Rails-5.2.8.1-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a)
![](https://img.shields.io/badge/Ruby-2.7.4-red) ![](https://travis-ci.com/Relocate08/Relocate-Back-End-Rails.svg?branch=main)
## About This Project
Sweater Weather is a Rails API that consumes two external API's ([OpenWeather API](https://openweathermap.org/api/one-call-3) and [MapQuest API](https://developer.mapquest.com/user/login/sign-up)) and exposes endpoints that generate weather and location data for an end user.

This was completed as a project for Turing School of Software and Design. Requirements for the project can be found here: [Whether, Sweater?](https://backend.turing.edu/module3/projects/sweater_weather/)

## Table of Contents
* [Local Setup](https://github.com/jusrez/sweater-weather/blob/main/README.md#local-setup)
* [Deployment](https://github.com/jusrez/sweater-weather/blob/main/README.md#deployment)
* [Endpoints](https://github.com/jusrez/sweater-weather/blob/main/README.md#endpoints)
  * [Retrieve weather for a city](https://github.com/jusrez/sweater-weather/blob/main/README.md#retrieve-weather-for-a-city)
  * [User Registration](https://github.com/jusrez/sweater-weather/blob/main/README.md#user-registration)
  * [Login](https://github.com/jusrez/sweater-weather/blob/main/README.md#login)
  * [Road Trip](https://github.com/jusrez/sweater-weather/blob/main/README.md#road-trip)
* [Contributors](https://github.com/jusrez/sweater-weather/blob/main/README.md#contributors)

## Local Setup
This project requires:
 * `Ruby 2.7.4`
 * `Rails 5.2.8.1`
### Setup Steps
 * Fork the repository
 * Clone the fork
 * Install gems and set up your database:
   * `bundle install`
   * `rails db:create`
   * `rails db:migrate`
 * Install Figaro
   * `bundle exec figaro install`
 * Update the `application.yml` file with `ENV` variables storing API keys for [OpenWeather API](https://openweathermap.org/api/one-call-3) and [MapQuest API](https://developer.mapquest.com/user/login/sign-up) (pages for obtaining API keys linked)
## Deployment
  Sweater Weather is not currently deployed remotely, but can be accessed and tested on a local server once it has been cloned down to your local machine.
## Endpoints
### Retrieve weather for a city

#### Return the current, daily (next 5 days), and hourly (next 8 hours) weather for a given location.

* `GET /api/v1/forecast`
  * Example Request:
  ```
  GET /api/v1/forecast?location=denver,co
  ```
  * Example Response:

  ```
  {
  "data": {
    "id": null,
    "type": "forecast",
    "attributes": {
      "current_weather": {
        "datetime": "2020-09-30 13:27:03 -0600",
        "temperature": 79.4,
        etc
      },
      "daily_weather": [
        {
          "date": "2020-10-01",
          "sunrise": "2020-10-01 06:10:43 -0600",
          etc
        },
        {...} etc
      ],
      "hourly_weather": [
        {
          "time": "14:00:00",
          "conditions": "cloudy with a chance of meatballs",
          etc
        },
        {...} etc
      ]
    }
  }
  ```

### User Registration

#### Create a user using a JSON payload and return the email and the newly generated api key of that user.

* `POST /api/v1/users`
  * Example Request: 

  ```
  {
  "email": "whatever@example.com",
  "password": "password",
  "password_confirmation": "password"
  }
  ```
  * Example Response:

  ```
  status: 201
  body:

  {
    "data": {
      "type": "users",
      "id": "1",
      "attributes": {
        "email": "whatever@example.com",
        "api_key": "jgn983hy48thw9begh98h4539h4"
      }
    }
  }
  ```

### Login

#### Login an existing user with a JSON payload that includes the registered users email and password.

* `POST /api/v1/sessions`
  * Example Request: 

  ```
  {
  "email": "whatever@example.com",
  "password": "password"
  }
  ```
  * Example Response:

  ```
  status: 200
  body:

  {
    "data": {
      "type": "users",
      "id": "1",
      "attributes": {
        "email": "whatever@example.com",
        "api_key": "jgn983hy48thw9begh98h4539h4"
      }
    }
  }
  ```
### Road Trip

#### Create a road trip using a JSON payload that will return the origin, destination, travel time, and arrival forecast.

* `POST /api/v1/road_trip`
  * Example Request: 

  ```
  {
  "email": "whatever@example.com",
  "password": "password"
  }
  ```
  * Example Response:

  ```
  status: 200
  body:

  {
    "data": {
      "id": null,
      "type": "roadtrip",
      "attributes": {
        "start_city": "Denver, CO",
        "end_city": "Estes Park, CO",
        "travel_time": "2 hours, 13 minutes"
        "weather_at_eta": {
          "temperature": 59.4,
          "conditions": "partly cloudy with a chance of meatballs"
        }
      }
    }
  }
  ```
         
## Contributors

- **Justin Ramirez** - *Turing Student* - [GitHub](https://github.com/jusrez) - [LinkedIn](https://www.linkedin.com/in/jusrez)


