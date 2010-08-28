require 'rubygems'
gem 'apify'

require 'apify/client'

client = Apify::Client.new(:host => 'localhost', :port => 3000, :user => 'api', :password => 'secret')
puts client.post('/api/hello', :name => 'Jack')
