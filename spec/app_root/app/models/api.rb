class Api < Apify::Api

  post :ping do
    respond do
      { 'message' => 'pong' }
    end
  end

  post :fail do
    respond do
      raise "error message"
    end
  end

  post :hello do
    schema :args do
      object('name' => string)
    end
    schema :value do
      object('message' => string)
    end
    respond do
      { 'message' => "Hello #{args['name']}" }
    end
  end

  post :echo_args do
    respond do
      args
    end
  end

  post :with_args_schema do
    schema :args do
      object("string_arg" => string)
    end
  end

  post :with_value_schema do
    schema :value do
      object("string_value" => string)
    end
    respond do
      args
    end
  end

end
