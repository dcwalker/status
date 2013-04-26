require 'spec_helper'

describe "/graph" do

  it "should respond to GET" do
    StatData.stub!(:find_max_value).and_return(1)
    get '/graph'
    last_response.should be_ok
    last_response.header['Content-Type'].should include 'application/json'
  end

end

describe "/flagged" do

  it "should respond to GET" do
    get '/flagged'
    last_response.should be_ok
  end

end