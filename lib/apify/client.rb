# Require these dependencies here, so code that just uses the client
# can just require 'apify/client' and is not dependent on Rails.
require 'json'
require 'restclient'
require 'apify/errors'
require 'cgi'

module Apify
  class Client

    def initialize(options)
      @host = options[:host] or raise "Missing :host parameter"
      @port = options[:port]
      @protocol = options[:protocol] || 'http'
      @user = options[:user]
      @password = options[:password]
    end
    
    def get(*args)
      request(:get, *args)
    end
    
    def post(*args)
      request(:post, *args)
    end
    
    def put(*args)
      request(:put, *args)
    end
    
    def delete(*args)
      request(:delete, *args)
    end
    
    private
    
    def request(method, path, args = nil)
      params = args ? { :args => args.to_json } : {}
      if [:get, :delete].include?(method)
        url = build_url(path, params)
        params = {}
      else
        url = build_url(path)
      end
      json = RestClient.send(method, url, params)
      JSON.parse(json)
    rescue RestClient::Unauthorized => e
      raise Apify::Unauthorized.new("Unauthorized")
    rescue RestClient::ExceptionWithResponse => e
      raise Apify::RequestFailed.new("API request failed with status #{e.http_code}", e.http_body)
    end

    def build_url(path, params = {})
      url =  ""
      url << @protocol
      url << '://'
      url << "#{@user}:#{@password}@" if @user
      url << @host
      url << ":#{@port}" if @port
      url << path
      unless params.empty?
        url << '?'
        url << params.collect { |k, v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&')
      end
      url
    end

  end
end
