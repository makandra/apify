class ApiController < Apify::ApiController

  attr_accessor :skip_authentication

  api Api
  authenticate :user => 'user', :password => 'password', :if => lambda { !skip_authentication }

end
