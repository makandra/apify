module Apify
  module SchemaHelper

    def optional(schema)
      schema.merge('optional' => true)
    end
    
    def object(properties = nil)
      { 'type' => 'object' }.tap do |schema|
        schema['properties'] = properties if properties
      end
    end

    def array(items = nil)
      { 'type' => 'array' }.tap do |schema|
        schema['items'] = items if items
      end
    end

    def string
      { 'type' => 'string' }
    end

    def boolean
      { 'type' => 'boolean' }
    end

    def enum(schema, allowed_values)
      schema.merge('enum' => allowed_values)
    end

    def number
      { 'type' => 'number' }
    end

    def integer
      { 'type' => 'integer' }
    end

    def sql_date
      { 'type' => 'string',
        'pattern' => Patterns::SQL_DATE.source }
    end

    def sql_datetime
      { 'type' => 'string',
        'pattern' => Patterns::SQL_DATETIME.source }
    end

    def email
      { 'type' => 'string',
        'pattern' => Patterns::EMAIL.source }
    end

  end
end
