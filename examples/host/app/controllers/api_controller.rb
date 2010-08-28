class ApiController < Apify::ApiController

  authenticate :user => 'api', :password => 'secret'

end
