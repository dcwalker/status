require 'spec_helper'
require 'json'

describe "/graph" do
  before(:each) do
    StatData.stub!(:find_max_value).and_return(1)
  end
  it "should respond to GET" do
    get '/graph'
    last_response.should be_ok
  end
  it "should respond with a hash in JSON form that has a key called graph" do
    get '/graph'
    last_response.should be_ok
    last_response.header['Content-Type'].should include 'application/json'
    JSON.parse(last_response.body).has_key?("graph").should be_true
  end
  context "within the graph element" do
    it "should have keys called title, type, total, yAxis, and datasequences" do
      get '/graph'
      last_response.should be_ok
      last_response.header['Content-Type'].should include 'application/json'
      JSON.parse(last_response.body)["graph"].has_key?("title").should be_true
      JSON.parse(last_response.body)["graph"].has_key?("type").should be_true
      JSON.parse(last_response.body)["graph"].has_key?("total").should be_true
      JSON.parse(last_response.body)["graph"].has_key?("yAxis").should be_true
      JSON.parse(last_response.body)["graph"].has_key?("datasequences").should be_true
    end
  end
end

describe "/flagged" do

  it "should respond to GET" do
    get '/flagged'
    last_response.should be_ok
  end

end