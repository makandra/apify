module Apify
  class Api
    class << self

      def action(method, name, args = {}, &block)
        method = method.to_sym
        name = name.to_sym
        if block
          action = Apify::Action.new(method, name, &block)
          indexed_actions[name][method] = action
          actions << action
        else
          action = indexed_actions[name][method] or raise "Unknown API action: #{name}"
          action.respond(args)
        end
      end

      def get(*args, &block)
        action(:get, *args, &block)
      end

      def post(*args, &block)
        action(:post, *args, &block)
      end

      def put(*args, &block)
        action(:put, *args, &block)
      end

      def delete(*args, &block)
        action(:delete, *args, &block)
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
