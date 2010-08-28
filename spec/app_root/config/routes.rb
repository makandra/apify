ActionController::Routing::Routes.draw do |map|

  Api.draw_routes(map)

  # map.connect 'api/hello', :controller => 'api', :action => 'hello', :conditions => { :method => :get }
  # map.connect 'api/fail', :controller => 'api', :action => 'fail', :conditions => { :method => :get }
  # map.connect 'api/echo_args', :controller => 'api', :action => 'echo_args', :conditions => { :method => :get }
  # map.connect 'api/with_args_schema', :controller => 'api', :action => 'with_args_schema', :conditions => { :method => :get }
  # map.connect 'api/with_value_schema', :controller => 'api', :action => 'with_value_schema', :conditions => { :method => :get }
  # map.connect 'api/songs', :controller => 'api', :action => 'index_songs', :conditions => { :method => :get }

end
