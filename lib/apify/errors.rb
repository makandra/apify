module Apify
  class RequestFailed < StandardError

    attr_reader :response_body

    def initialize(message, response_body = nil)
      super(message)
      @response_body = response_body
    end

  end
end
