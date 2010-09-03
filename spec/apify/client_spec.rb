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
    stub_request(:post, 'http://host/api/hello').to_return(:body => '{}')
    args = { :name => 'Jack' }
    client.post('/api/hello', args)
    WebMock.should have_requested(:post, "http://host/api/hello").with(:body => { :args => args.to_json })
  end

  it 'should not transmit an args parameter if the arguments are blank' do
    client = Apify::Client.new(:host => 'host')
    stub_request(:get, 'http://host/api/ping').to_return(:body => '{}')
    client.get('/api/ping')
    WebMock.should have_requested(:get, "http://host/api/ping")
  end

  it "should call GET actions correctly" do
    client = Apify::Client.new(:host => 'host')
    args = { :name => 'Jack' }
    stub_request(:get, 'http://host/api/hello').with(:query => { :args => args.to_json }).to_return(:body => '{}')
    client.get('/api/hello', args)
    WebMock.should have_requested(:get, "http://host/api/hello").with(:query => { :args => args.to_json })
  end

  it "should connect using SSL" do
    client = Apify::Client.new(:host => 'host', :protocol => 'https')
    stub_request(:get, 'https://host/api/ping').to_return(:body => '{}')
    client.get('/api/ping')
    WebMock.should have_requested(:get, "https://host/api/ping")
  end

  it 'should allow to use a non-standard port' do
    client = Apify::Client.new(:host => 'host', :port => '8080')
    stub_request(:get, 'http://host:8080/api/ping').to_return(:body => '{}')
    client.get('/api/ping')
    WebMock.should have_requested(:get, "http://host:8080/api/ping")
  end

end

