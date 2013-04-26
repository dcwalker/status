require 'spec_helper'

describe "Query" do
  context ".as_json" do
    it "should return a hash with a title key, a refreshEveryNSeconds key, a color key and a datapoints key" do
      StatData.transaction do
        Time.stub!(:now).and_return(Time.parse("2013-04-09 00:01:00"))
        query = Query.create(name: "everything", sql: "select *", color: "red", data_type: "list")
        query.as_json.has_key?(:title).should be_true
        query.as_json.has_key?(:refreshEveryNSeconds).should be_true
        query.as_json.has_key?(:color).should be_true
        query.as_json.has_key?(:datapoints).should be_true
        raise ActiveRecord::Rollback
      end
    end
    it "should return the name as the title key" do
      StatData.transaction do
        Time.stub!(:now).and_return(Time.parse("2013-04-09 00:01:00"))
        query = Query.create(name: "everything", sql: "select *", color: "red", data_type: "list")
        query.as_json[:title].should == "everything"
        raise ActiveRecord::Rollback
      end
    end
    it "should return 120 as the refreshEveryNSeconds key" do
      StatData.transaction do
        Time.stub!(:now).and_return(Time.parse("2013-04-09 00:01:00"))
        query = Query.create(name: "everything", sql: "select *", color: "red", data_type: "list")
        query.as_json[:refreshEveryNSeconds].should == "120"
        raise ActiveRecord::Rollback
      end
    end
    it "should return the color as the color key" do
      StatData.transaction do
        Time.stub!(:now).and_return(Time.parse("2013-04-09 00:01:00"))
        query = Query.create(name: "everything", sql: "select *", color: "red", data_type: "list")
        query.as_json[:color].should == "red"
        raise ActiveRecord::Rollback
      end
    end
    it "should return the StatData for its query as the datapoints key" do
      StatData.transaction do
        Time.stub!(:now).and_return(Time.parse("2013-04-09 00:01:00"))
        query = Query.create(name: "everything", sql: "select *", color: "red", data_type: "list")
        StatData.stub!(:find_averages_for_query).with(query.id).and_return("DATA!")
        query.as_json[:datapoints].should == "DATA!"
        raise ActiveRecord::Rollback
      end
    end
  end
end
