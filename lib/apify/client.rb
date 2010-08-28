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
      url = build_url(path)
      args ||= {}
      json = RestClient.send(method, url, :args => args.to_json)
      JSON.parse(json)
    rescue RestClient::Unauthorized => e
      raise Apify::RequestFailed.new("Unauthorized")
    rescue RestClient::ExceptionWithResponse => e
      raise Apify::RequestFailed.new("API request failed with status #{e.http_code}", e.http_body)
    end

    def build_url(path)
      url =  ""
      url << @protocol
      url << '://'
      url << "#{@user}:#{@password}@" if @user
      url << @host
      url << ":#{@port}" if @port
      url << path
    end

  end
end
