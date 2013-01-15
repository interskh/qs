# Welcome to Quantified Self
This is a project i create to analyze myself, as part of Quantified Self movement.

Demo Site: http://qs.bigkyle.com

# Getting Started

## DB Config
Example db config is under config/database.example.yml

## ENV Config
Dev config is under config/initializers/dev_environment.rb

    # config/initializers/dev_environment.rb
    unless Rails.env.production?
      ENV['FOURSQUARE_APP_ID'] = 'foursquare_app_id'
      ENV['FOURSQUARE_APP_SECRET'] = 'foursquare_app_secret'
    end
