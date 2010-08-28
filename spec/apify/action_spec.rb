require 'spec_helper'

describe Apify::Action do

  describe '#uid' do

    it "should return a string uniquely describing the action within an API" do
      action = Apify::Action.new(:post, :hello_world) {}
      action.uid.should == 'post_hello_world'
    end

  end

  describe '#example' do

    it "should return an example for a JSON object matching the schema" do
      action = Apify::Action.new(:post, :hello_world) do
        schema :value do
          object(
            'string_property' => string,
            'integer_property' => integer
          )
        end
      end

      action.example(:value).should == {
        'string_property' => 'string',
        'integer_property' => 123
      }

    end

  end

end