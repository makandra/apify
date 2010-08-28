require 'spec_helper'

describe 'Convenient testing of Api models' do

  it 'should allow to test response objects directly' do
    Api.post(:hello, :name => 'Jack').should == { 'message' => 'Hello Jack' }
  end

  it 'should raise an exception on errors' do
    expect { Api.post(:hello) }.to raise_error(Apify::Invalid)
    expect { Api.post(:fail) }.to raise_error(StandardError)
  end

end
