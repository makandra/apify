Apify
=====

Apify lets you bolt a [JSON](http://en.wikipedia.org/wiki/JSON) API onto your Rails application.
Optional features are auto-generated API documentation, request validation with [JSON Schema](http://json-schema.org/)
and a client class to consume Apify APIs from Ruby code.


Two minute quickstart
---------------------

Install the gem with

    sudo gem install apify

For Rails 2, add the following to your `environment.rb`:

    config.gem 'apify'

For Rails 3, add the following to your `Gemfile`:

    gem 'apify'

Describe your API actions in `models/api.rb`:

    class Api < Apify::Api
      get :ping do
        respond do
          { 'message' => 'pong' }
        end
      end
    end

Create a controller to serve your API in `controllers/api_controller.rb`:

    class ApiController < Apify::ApiController
      api Api
    end

Connect the routes to your API in `config/routes.rb`:

    ActionController::Routing::Routes.draw do |map|
      Api.draw_routes(map)
    end

You have now exposed an API action under `http://host/api/ping`.

An example for this setup can also be found under the `examples/host` directory inside the repository.


Protocol
--------

If you are planning to consume your Apify API with the `Apify::Client` class, you won't need to know most of this. Nonetheless, this is what you're getting into:

- Apify is about sending JSON objects (hashes) back and forth. No fancy envelope formats.
- An Apify API defines actions with a name and HTTP method (`GET, POST, PUT, DELETE`).
- API actions are accessed over HTTP. Each action gets its own route.
- API actions can take arguments. Those are serialized into a **single** HTTP parameter `args` as JSON. This is to simplify client code that consumes your API (nested params are hard).
- Successful responses are returned with a status of 200 (OK).
- The body of a successful response is always a hash, serialized as JSON.
- Requests that have errors are returned with a status that is **not** 200. The body of a error response is an error message in the response's content type (won't be JSON in most cases).


Defining API actions
--------------------

API actions are defined in a model such as `models/api.rb`:

- This model needs to inherit from `Apify::Api`.
- An API method has a name and a  HTTP method (`GET, POST, PUT, DELETE`)
- An API action always returns a hash. If an API action returns nil, Apify will turn that into an empty hash for you.

Here is an example for a simple, reading API action:

    get :ping do
      respond do
        { 'message' => 'pong' }
      end
    end

Action arguments can be accessed through the `args` hash. Its keys are always strings, never symbols.

Here is an example for an API action that takes an argument:

    post :hello do
      respond do
        { 'message' => 'Hello ' + args['name'] }
      end
    end


Schemas
-------

You can describe the expected format of method arguments and response values using [JSON Schema](http://json-schema.org/). This lets you define rules like that an argument is required or must be in a given format.

Schemas are an optional feature, but providing schemas has some benefits:

- Your actions don't need to handle unexpected arguments (remember that strangers are going to call your code).
- You don't need to worry about responding with values that break your own contract. Apify will validate your own responses and raise an error if they don't validate.
- Apify can auto-generate public documentation for actions with schemas. This documentation will contain generated examples for a successful request and response and also offer your schemas for download.

You can provide a schema for arguments, a schema for response values, or both. Here is the `hello` action from the above example with schemas:

    post :hello do

      schema :args do
        object('name' => string)
      end

      schema :value do
        object('message' => string)
      end

      respond do
        { 'message' => 'Hello ' + args['name'] }
      end

    end

Your API now allows to download the schema and an auto-generated example in JSON format:

- POST http://host/api/hello?schema=args
- POST http://host/api/hello?example=args
- POST http://host/api/hello?schema=value
- POST http://host/api/hello?example=value

Here is another example for a more complex schema:

    get :contacts do
      schema :value do
        array(
          object(
            'name' => string,
            'phone' => integer,
            'phone_type' => enum(string, 'home', 'office'),
            'email' => optional(email),
            'favorite' => boolean
          )
        )
      end
    end

Note that the schema considers an key/value pair to be "present" when the key is present, even if the value is `nil`. That means if an object entry is optional and you want to omit that entry, you need to leave out the entire key/value pair.


Auto-generated API documentation
--------------------------------

Every Apify API comes with auto-generated HTML documentation:

- The documentation can be accessed from the `docs` action of an `ApiController`, e.g. http://host/api/docs
- The documentation contains parts of this README (protocol, instructions to use the Ruby client)
- If your actions have schemas, the documentation includes those schemas and request/response examples generated from them.

You can give your actions descriptions to make the API documentation even more useful:

    post :hello do

      description 'Says hello to the given name.'

      respond do
        { 'message' => 'Hello ' + args['name'] }
      end

    end



Authentication
--------------

If your API uses a single username and password for all requests, you can activate basic authentication like this:

    class ApiController < ApplicationController::Base
      api Api
      authenticate :user => 'api', :password => 'secret'
    end

If your use case is more complex, just roll your own authentication. Your `ApiController` is just a regular controller.


Consuming an API with the Ruby client
-------------------------------------

An easy way to consume an Apify API is to use the <code>Apify::Client</code> class:

- The client calls an Apify API with a Ruby hash as argument and returns the response as a Ruby hash.
- It takes care of the protocol details and lets your users focus on exchanging data.
- Your users will only need the `apify` gem. There are no dependencies on Rails.
- The auto-generated documentation contains these instructions on how to install and use the client class.

You already know how to require the `apify` gem from a Rails application. This is how you require the client class when your code is not a Rails application:

    require 'rubygems'
    gem 'apify'
    require 'apify/client'

Here is an example for how to use the client class:

    client = Apify::Client.new(:host => 'localhost:3000', :user => 'api', :password => 'secret')
    client.post('/api/hello', :name => 'Jack') # { 'message' => 'Hello Jack' }

Errors can be caught and inspected like this:

    begin
      client.get('/api/hello', :name => 'Jack') # { 'message' => 'Hello Jack' }
    rescue Apify::RequestFailed => e
      puts "Oh no! The API request failed."
      puts "Message: #{e.message}"
      puts "Response: #{e.response_body}"
    end

Use the `:protocol` option to connect using SSL:

    client = Apify::Client.new(:host => 'api.site.com', :user => 'api', :password => 'secret', :protocol => 'https')

An example for an API client can be found under the `examples/client` directory inside the repository.


Dealing with dates and timestamps
---------------------------------

Unfortunately dates and timestamps are not among the data types defined by JSON and JSON Schema. You can work around this in any way you like, but Apify supports a default approach:

- The workaround supported by Apify is to handle a date as a string formatted like "2011-05-01" and a timestamp as a string formatted like "2011-05-01 12:00:04".
- Aside from being easy to parse, you can feed such strings into a model's date or time field and ActiveRecord will convert them into `Date` and `Time` objects.
- Apify gives you helper methods `sql_date` and `sql_datetime` to support this pattern in your schemas and actions.

Here are examples for actions that deal with dates and timestamps this way:

    get :now do
      schema :value do
        object('now' => sql_datetime)
      end
      respond do
        { 'now' => sql_datetime(Time.now) }
      end
    end

    get :today do
      schema :value do
        object('today' => sql_date)
      end
      respond do
        { 'today' => sql_date(Date.today) }
      end
    end


Testing API actions
-------------------

Since your API actions end up being vanilla Ruby methods that turn argument hashes into value hashes, you can test them without special tools.

Here is an example in RSpec:

    describe Api, 'hello' do

      it 'should greet the given name' do
        Api.post(:hello, :name => 'Jack').should == { 'message' => 'Hello Jack' }
      end

      it 'should require a name argument' do
        expect { Api.post(:hello) }.to raise_error(Apify::Invalid)
      end

    end


Custom routing
--------------

You can create a route for each action of an API by adding this to your `config/routes.rb`:

    ActionController::Routing::Routes.draw do |map|
      Api.draw_routes(map)
    end

This will create URLs like `/api/ping`, `/api/hello`, etc. You can change the `/api` prefix like this:

    ActionController::Routing::Routes.draw do |map|
      Api.draw_routes(map, :base_path => 'interface/v1')
    end

You can also forego the automatic route generation completely and roll your own URLs:

    ActionController::Routing::Routes.draw do |map|
      map.connect 'api/ping', :controller => 'api', :action => 'ping', :conditions { :method => :get }
      map.connect 'api/hello', :controller => 'api', :action => 'hello', :conditions { :method => :post }
    end


Rails 3 compatibility
---------------------

We cannot guarantee Rails 3 compatibility at this point, but we will upgrade the gem when Rails 3 is released.

Credits
-------

Henning Koch ([makandra.com](http://makandra.com/), [gem-session.com](http://gem-session.com/))
