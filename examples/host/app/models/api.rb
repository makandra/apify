class Api < Apify::Api

  post :hello do

    description 'Greets the given name.'

    schema :args do
      object('name' => string)
    end

    schema :value do
      object('message' => string)
    end

    respond do
      { 'message' => "Hello, #{args['name']}"}
    end

  end

end
