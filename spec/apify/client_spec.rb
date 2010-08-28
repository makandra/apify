require 'spec_helper'

describe Apify::Client do

  it "raise an exception if authorization is missing" do
    client = Apify::Client.new(:host => 'host')
    stub_http_request(:get, 'http://host/api').to_return(:status => 401, :body => 'the body')
    expect { client.get '/api' }.to raise_error(Apify::RequestFailed)
  end

  it "raise an exception if there is a server error" do
    client = Apify::Client.new(:host => 'host')
    stub_http_request(:get, 'http://host/api').to_return(:status => 500, :body => 'the body')
    expect { client.get '/api' }.to raise_error(Apify::RequestFailed)
  end

  it "should return the parsed JSON object if the request went through" do
    client = Apify::Client.new(:host => 'host')
    stub_http_request(:get, 'http://host/api').to_return(:status => 200, :body => '{ "key": "value" }')
    client.get('/api').should == { 'key' => 'value' }
  end

end

