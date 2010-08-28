module Apify
  class Api
    class << self

      def action(method, name, &block)
        method = method.to_sym
        name = name.to_sym
        if block
          action = Apify::Action.new(method, name, &block)
          indexed_actions[name][method] = action
          actions << action
        else
          indexed_actions[name][method] or raise "Unknown API action: #{name}"
        end
      end

      def get(name, &block)
        action(:get, name, &block)
      end

      def post(name, &block)
        action(:post, name, &block)
      end

      def put(name, &block)
        action(:put, name, &block)
      end

      def delete(name, &block)
        action(:delete, name, &block)
      end

      def actions
        @actions ||= []
      end

      def indexed_actions
        @indexed_actions ||= Hash.new { |hash, k| hash[k] = {} }
      end

      def draw_routes(map, options = {})
        options[:base_path] ||= 'api'
        options[:controller] ||= 'api'
        indexed_actions.each do |name, methods|
          methods.each do |method, action|
            connect_route(map, name, method, options)
          end
        end
        connect_route(map, 'docs', :get, options)
      end

      private

      def connect_route(map, name, method, options)
        options = options.dup
        base_path = options.delete :base_path
        map.connect(
          base_path ? "#{base_path}/#{name}" : name,
          options.merge(:action => name.to_s, :conditions => { :method => method })
        )
      end

    end
  end
end
