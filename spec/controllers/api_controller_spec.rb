require 'spec_helper'

describe ApiController do

  authenticate = lambda do |*args|
    user = args[0] || 'user'
    password = args[1] || 'password'
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, password)
  end

  describe 'authentication' do

    it "should deny access with the wrong user" do
      instance_exec('wrong-user', 'password', &authenticate)
      post :ping
      response.code.should == '401'      
    end

    it "should deny access with the wrong password" do
      instance_exec('user', 'wrong-password', &authenticate)
      post :ping
      response.code.should == '401'
    end

    it "should grant access with the correct user and password" do
      instance_exec('user', 'password', &authenticate)
      post :ping
      response.code.should == '200'
    end

    it "should allow an option to skip authentication" do
      controller.skip_authentication = true
      post :ping
      response.code.should == '200'
      controller.skip_authentication = false
      post :ping
      response.code.should == '401'
    end

  end

  describe 'error handling' do

    it 'should fill exception messages into the response body and return a 500 error code' do
      instance_exec(&authenticate)
      post :fail
      response.code.should == '500'
      response.body == 'error message'
    end

  end

  describe 'args' do

    it 'should have access to the args' do
      instance_exec(&authenticate)
      args = {'foo' => 'bar'}
      post :echo_args, :args => args.to_json
      response.code.should == '200'
      JSON.parse(response.body).should == args
    end

  end

  describe 'argument schemas' do

    before :each do
      instance_exec(&authenticate)
    end

    it "should validate the presence of a property" do
      post :with_args_schema, :args => {}.to_json
      response.code.should == '500'
      response.body.should include('Invalid request args')
      response.body.should include('string_arg is missing')
    end

    it "should validate value types" do
      post :with_args_schema, :args => {'string_arg' => 123}.to_json
      response.code.should == '500'
      response.body.should include('Invalid request args')
      response.body.should include('a string is required')
    end

    it "should allow requests that fit the schema" do
      post :with_args_schema, :args => {'string_arg' => 'a string'}.to_json
      response.code.should == '200'
    end

    it "should render the schema if requested" do
      post :with_args_schema, :schema => 'args'
      response.code.should == '200'
      JSON.parse(response.body).should == {
        "type" => "object",
        "properties" => {
          "string_arg" => { "type" => "string" }
      }}
    end

  end

  describe 'value schemas' do

    before :each do
      instance_exec(&authenticate)
    end

    it "should validate the presence of a property" do
      post :with_value_schema, :args => {}.to_json
      response.code.should == '500'
      response.body.should include('Invalid response value')
      response.body.should include('string_value is missing')
    end

    it "should validate value types" do
      post :with_value_schema, :args => {'string_value' => 123}.to_json
      response.code.should == '500'
      response.body.should include('Invalid response value')
      response.body.should include('a string is required')
    end

    it "should return responses that fit the schema" do
      post :with_value_schema, :args => {'string_value' => 'a string'}.to_json
      response.code.should == '200'
      JSON.parse(response.body).should == {'string_value' => 'a string'}
    end    

    it "should render the schema if requested" do
      post :with_value_schema, :schema => 'value'
      response.code.should == '200'
      JSON.parse(response.body).should == {
        "type" => "object",
        "properties" => {
          "string_value" => { "type" => "string" }
      }}
    end

  end

  describe 'schema helpers' do

    before :each do
      instance_exec(&authenticate)
    end

    describe '#sql_date helper' do

      it 'should match a date as seen in SQL' do
        get :schema_with_sql_date, :args => {'date' => '2011-05-01'}.to_json
        response.code.should == '200'
      end

      it 'should not match an invalid string' do
        get :schema_with_sql_date, :args => {'date' => '01.05.2011'}.to_json
        response.code.should == '500'
      end

    end

    describe '#sql_datetime helper' do

      it 'should match a timestamp as seen in SQL' do
        get :schema_with_sql_datetime, :args => {'datetime' => '2011-05-01 12:10:59'}.to_json
        response.code.should == '200'
      end

      it 'should not match an invalid string' do
        get :schema_with_sql_datetime, :args => {'datetime' => '2011-05-01'}.to_json
        response.code.should == '500'
      end

    end

    describe '#email helper' do

      it 'should match an email address' do
        get :schema_with_email, :args => {'email' => 'some.guy@some.domain.tld'}.to_json
        response.code.should == '200'
      end

      it 'should not match an invalid string' do
        get :schema_with_email, :args => {'email' => 'some.guy'}.to_json
        response.code.should == '500'
      end

    end

  end

  describe 'auto-generated documentation' do
    integrate_views

    it 'should render auto-generated API documentation' do
      instance_exec(&authenticate)
      get :docs
      response.code.should == '200'
      response.body.should include('ping')
      response.body.should include('fail')
      response.body.should include('echo_args')
    end

  end

end

