# Welcome to Quantified Self
This is a project i create to analyze myself, as part of Quantified Self movement.

# Getting Started

## DB Config
Example db config is under config/database.example.yml

## ENV Config
Dev config is under config/initializers/dev_environment.rb

    # config/initializers/dev_environment.rb
    unless Rails.env.production?
      ENV['FOURSQUARE_APP_ID'] = 'K20QNOKLAUBF0LSZI0U135ET4EFVZ3TFFHR4WQPXEKNU3WXP'
      ENV['FOURSQUARE_APP_SECRET'] = '20ZAJXGVLJHE40WBWRFY3CNAN2BF1Z1RVD0DGLV4OLAIDOHQ'
    end
