
module Apify
  class Exchange

    attr_reader :args, :value

    def initialize
      @value = nil
      @error = false
      @args = nil
    end

    def successful?
      not @error
    end

    def respond(args, action)
      logging_errors do
        @args = args
        validate(@args, action.schema(:args), 'Invalid request args')
        @value = instance_eval(&action.responder) || {}
        validate(@value, action.schema(:value), 'Invalid response value')
      end
      successful?
    end

    private

    attr_writer :value

    def validate(object, schema, message_prefix)
      JSON::Schema.validate(object, schema) if schema
    rescue JSON::Schema::ValueError => e
      raise "#{message_prefix}: #{e.message}"
    end

    def logging_errors(&block)
      block.call
    rescue Exception => e
      @error = true
      @value = e.message
    end
    
    def sql_datetime(time)
      time.present? ? time.strftime("%Y-%m-%d %H:%M:%S") : nil
    end

    def sql_date(date)
      date.present? ? date.strftime("%Y-%m-%d") : nil
    end

  end
end
