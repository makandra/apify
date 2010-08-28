module Apify
  class ApiController < ActionController::Base

    helper ApifyHelper

    class << self

      def authenticate(options)
        @user = options[:user] or raise "Missing user for authentication"
        @password = options[:password] or raise "Missing password for authentication"
        @authenticate_condition = options[:if] || lambda { true }
      end

      def api(api)
        @api = api
        @api.indexed_actions.each do |name, methods|
          define_method name do
            if action = methods[request.method]
              if params[:schema].present?
                render_schema(params[:schema], action)
              elsif params[:example].present?
                render_example(params[:example], action)
              else
                respond_with_action(action)
              end
            else
              render_method_not_allowed(request.method)
            end
          end
        end
        @api
      end

    end

    skip_before_filter :verify_authenticity_token

    before_filter :require_api_authentication

    def docs
      render 'apify/api/docs', :layout => false
    end

    def api
      configuration(:api) || self.class.api(::Api)
    end

    def authentication_configured?
      !!@authenticate_condition
    end

    helper_method :api, :authentication_configured? 

    private

    def configuration(symb)
      self.class.instance_variable_get("@#{symb}")
    end
    
    def respond_with_action(action)
      args = params[:args].present? ? JSON.parse(params[:args]) : {}
      exchange = action.respond(args)
      render_api_response(exchange, "#{action.name}.json")
    end

    def render_api_response(exchange, filename)
      # p exchange.value
      if exchange.successful?
        send_data exchange.value.to_json, :status => '200', :type => 'application/json', :filename => filename
      else
        send_data exchange.value, :status => '500', :type => 'text/plain', :filename => filename
      end
    end

    def render_method_not_allowed(method)
      send_data "Method not allowed: #{method}", :status => 405, :type => 'text/plain'
    end

    def render_schema(nature, action)
      send_data JSON.pretty_generate(action.schema(nature)), :status => 200, :type => "application/schema+json", :filename => "#{action.name}.schema.json"
    end

    def render_example(nature, action)
      send_data JSON.pretty_generate(action.example(nature)), :status => 200, :type => "application/json", :filename => "#{action.name}.example.json"
    end

    def require_api_authentication
      condition = configuration(:authenticate_condition)
      if condition && instance_eval(&condition)
        authenticate_or_request_with_http_basic do |user, password|
          required_user = configuration(:user)
          required_password = configuration(:password)
          required_user.present? && required_password.present? && user.strip == required_user && password.strip == required_password
        end
      end
    end
    
  end
end
