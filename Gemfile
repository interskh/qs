source 'http://rubygems.org'

ruby "1.9.3"

gem 'rails', '3.2.10'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'unicorn'

gem 'haml'
gem "settingslogic"
gem 'json'
gem 'typhoeus', '0.2.2'

# foursquare
gem 'quimby', :git => 'git@github.com:interskh/quimby.git'

# Deploy with Capistrano
# gem 'capistrano'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "debugger"
end

group :development, :test do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end
