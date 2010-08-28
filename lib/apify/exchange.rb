
module Apify
  class Exchange

    attr_reader :args, :value

    def initialize
      @value = nil
      @args = nil
    end

    def respond(args, action)
      # hash_class = defined?(HashWithIndifferentAccess) ? HashWithIndifferentAccess : ActiveSupport::HashWithIndifferentAccess
      @args = args.stringify_keys
      validate(@args, action.schema(:args), 'Invalid request args')
      @value = instance_eval(&action.responder) || {}
      @value.stringify_keys!
      validate(@value, action.schema(:value), 'Invalid response value')
      @value
    end

    private

    attr_writer :value

    def validate(object, schema, message_prefix)
      JSON::Schema.validate(object, schema) if schema
    rescue JSON::Schema::ValueError => e
      @value = nil
      raise Apify::Invalid.new("#{message_prefix}: #{e.message}")
    end

    def sql_datetime(time)
      time.present? ? time.strftime("%Y-%m-%d %H:%M:%S") : nil
    end

    def sql_date(date)
      date.present? ? date.strftime("%Y-%m-%d") : nil
    end

  end
end
