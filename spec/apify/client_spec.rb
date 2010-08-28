require 'spec_helper'

describe Apify::Client do

  it "raise an exception if authorization is missing" do
    client = Apify::Client.new(:host => 'host')
    stub_request(:post, 'http://host/api/method').to_return(:status => 401, :body => 'the body')
    expect { client.post '/api/method' }.to raise_error(Apify::RequestFailed)
  end

  it "raise an exception if there is a server error" do
    client = Apify::Client.new(:host => 'host')
    stub_request(:post, 'http://host/api/method').to_return(:status => 500, :body => 'the body')
    expect { client.post '/api/method' }.to raise_error(Apify::RequestFailed)
  end

  it "should return the parsed JSON object if the request went through" do
    client = Apify::Client.new(:host => 'host')
    stub_request(:post, 'http://host/api/method').to_return(:status => 200, :body => '{ "key": "value" }')
    client.post('/api/method').should == { 'key' => 'value' }
  end

  it "should call API methods with arguments" do
    client = Apify::Client.new(:host => 'host')
    stub_request(:post, 'http://host/api/hello').to_return(:status => 200, :body => '{}')
    args = { :name => 'Jack' }
    client.post('/api/hello', args)
    WebMock.should have_requested(:post, "http://host/api/hello").with(:body => { :args => args.to_json })
  end

  it "should call GET actions correctly" do
    client = Apify::Client.new(:host => 'host')
    args = { :name => 'Jack' }
    stub_request(:get, 'http://host/api/hello').with(:query => { :args => args.to_json }).to_return(:status => 200, :body => '{}')
    client.get('/api/hello', args)
    WebMock.should have_requested(:get, "http://host/api/hello").with(:query => { :args => args.to_json })
  end

end

