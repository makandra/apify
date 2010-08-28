$: << File.join(File.dirname(__FILE__), "/../lib" )

# Set the default environment to sqlite3's in_memory database
ENV['RAILS_ENV'] ||= 'in_memory'

# Load the Rails environment and testing framework
require "#{File.dirname(__FILE__)}/app_root/config/environment"
require "#{File.dirname(__FILE__)}/../lib/apify"

require 'rubygems'

gem 'jsonschema', '=2.0.0'
gem 'webmock', '=1.3.4'
gem 'rest-client', '=1.5.1'

require 'spec/rails'
require 'jsonschema'
require 'webmock/rspec'
require 'restclient'

# Undo changes to RAILS_ENV
silence_warnings {RAILS_ENV = ENV['RAILS_ENV']}

# Run the migrations
ActiveRecord::Migrator.migrate("#{Rails.root}/db/migrate")

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.include WebMock
end
