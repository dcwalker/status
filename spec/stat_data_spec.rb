require 'spec_helper'

describe "StatData" do
  context ".find_averages_for_query" do
    it "should average the data over 10 minute periods" do
      StatData.transaction do
        Time.stub!(:now).and_return(Time.parse("2013-04-09 21:05:00"))
        StatData.create(query_id: 1, value: 1)
        Time.stub!(:now).and_return(Time.parse("2013-04-09 21:09:00"))
        StatData.create(query_id: 1, value: 3)
        Time.stub!(:now).and_return(Time.parse("2013-04-09 21:11:00"))
        StatData.create(query_id: 1, value: 100)
        StatData.find_averages_for_query(1).first.value.should == 2
        raise ActiveRecord::Rollback
      end
    end
    it "should only average the data for the given query id" do
      StatData.transaction do
        Time.stub!(:now).and_return(Time.parse("2013-04-09 21:10:00"))
        StatData.create(query_id: 2, value: 1)
        Time.stub!(:now).and_return(Time.parse("2013-04-09 21:10:00"))
        StatData.create(query_id: 1, value: 3)
        Time.stub!(:now).and_return(Time.parse("2013-04-09 21:11:00"))
        StatData.create(query_id: 1, value: 9)
        StatData.find_averages_for_query(1).each do |result|
          result.query_id.should == 1
        end
        raise ActiveRecord::Rollback
      end
    end
    it "should only show averages from the past 12 hours" do
      StatData.transaction do
        Time.stub!(:now).and_return(Time.parse("2013-04-09 00:00:00"))
        StatData.create(query_id: 1, value: 100)
        Time.stub!(:now).and_return(Time.parse("2013-04-09 21:05:00"))
        StatData.create(query_id: 1, value: 1)
        Time.stub!(:now).and_return(Time.parse("2013-04-09 21:09:00"))
        StatData.create(query_id: 1, value: 3)
        StatData.find_averages_for_query(1).first.value.should == 2
        raise ActiveRecord::Rollback
      end
    end
  end
  context ".find_max_value" do
    it "should return the maximum (average) value regardless of query id" do
      StatData.transaction do
        Time.stub!(:now).and_return(Time.parse("2013-04-09 21:10:00"))
        StatData.create(query_id: 1, value: 1)
        Time.stub!(:now).and_return(Time.parse("2013-04-09 21:10:00"))
        StatData.create(query_id: 1, value: 10)
        Time.stub!(:now).and_return(Time.parse("2013-04-09 21:11:00"))
        StatData.create(query_id: 2, value: 3)
        StatData.find_max_value.should == 5
        raise ActiveRecord::Rollback
      end
    end
    it "should only show the maximum (average) value from the past 12 hours" do
      StatData.transaction do
        Time.stub!(:now).and_return(Time.parse("2013-04-09 00:01:00"))
        StatData.create(query_id: 1, value: 10)
        Time.stub!(:now).and_return(Time.parse("2013-04-09 21:05:00"))
        StatData.create(query_id: 1, value: 1)
        Time.stub!(:now).and_return(Time.parse("2013-04-09 21:09:00"))
        StatData.create(query_id: 1, value: 3)
        StatData.find_max_value.should == 2
        raise ActiveRecord::Rollback
      end
    end
  end
  context ".as_json" do
    it "should return a hash with a title key and a value key" do
      StatData.transaction do
        Time.stub!(:now).and_return(Time.parse("2013-04-09 00:01:00"))
        stat_data = StatData.create(query_id: 1, value: 1)
        stat_data.as_json.has_key?(:title).should be_true
        stat_data.as_json.has_key?(:value).should be_true
        raise ActiveRecord::Rollback
      end
    end
    it "should return the created at time as the title key in the form HH:MM" do
      StatData.transaction do
        Time.stub!(:now).and_return(Time.parse("2013-04-09 00:01:00"))
        stat_data = StatData.create(query_id: 1, value: 1)
        stat_data.as_json[:title].should == "00:01"
        raise ActiveRecord::Rollback
      end
    end
    it "should return the value as the value key" do
      StatData.transaction do
        Time.stub!(:now).and_return(Time.parse("2013-04-09 00:01:00"))
        stat_data = StatData.create(query_id: 1, value: 1)
        stat_data.as_json[:value].should == 1
        raise ActiveRecord::Rollback
      end
    end
  end
end
