module Apify
  class Action

    attr_reader :name, :description, :method

    def initialize(method, name, &block)
      @method = method
      @name = name
      @schemas = Hash.new({}.freeze)
      instance_eval(&block)
    end

    def schema(nature, &block)
      nature = nature.to_sym
      if block
        @schemas[nature] = eval_schema(block)
      else
        @schemas[nature]
      end
    end

    def respond(args = nil, &block)
      if block
        @responder = block
      else
        Apify::Exchange.new.tap do |exchange|
          exchange.respond(args, self)
        end
      end
    end

    def description(description = nil, &block)
      if description || block
        @description = description ? description : block.call
      else
        @description
      end
    end

    def takes_args?
      schema(:args) != {}
    end

    def returns_value?
      schema(:value) != {}
    end

    def responder
      @responder || lambda {}
    end

    def example(schema_nature)
      example_for_schema(schema(schema_nature))
    end

    def uid
      "#{method}_#{name}"
    end

    private

    def example_for_schema(schema)
      case schema['type']
        when 'object'
          {}.tap do |object|
            if properties = schema['properties']
              properties.each do |key, value|
                object[key] = example_for_schema(value)
              end
            end
          end
        when 'array'
          [].tap do |array|
            if items = schema['items']
              array.concat [example_for_schema(items)] * 2
            end
          end
        when 'boolean'
          true
        when 'number'
          2.5
        when 'integer'
          123
        when 'string'
          'string'
        else
         raise "Unknown schema type: #{schema['type']}"
      end
    end

    def eval_schema(schema)
      lathe = Object.new
      lathe.extend Apify::SchemaHelper
      lathe.instance_eval(&schema)
    end

  end
end
