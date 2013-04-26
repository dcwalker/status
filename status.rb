#!/usr/bin/env ruby
# encoding: UTF-8

require 'sinatra'
require 'json'
require 'sqlite3'
require 'yaml'
require "active_record"

require File.join(File.expand_path(File.dirname(__FILE__)), "lib", 'configured_connection')
require File.join(File.expand_path(File.dirname(__FILE__)), "lib", 'stat_data')
require File.join(File.expand_path(File.dirname(__FILE__)), "lib", 'query')

get '/flagged*' do
  db = SQLite3::Database.new "#{ENV['HOME']}/Library/Caches/com.omnigroup.OmniFocus/OmniFocusDatabase2"
  data = db.execute( "select name from Task where effectiveFlagged = 1 and dateCompleted is null;" ).flatten
  erb :table, :locals => {:title => "OmniFocus Flagged Tasks", :rows => data}
end

get '/graph*' do
  content_type :json
  max_value = StatData.find_max_value
  return {
          "graph" => {
                      :title => "OmniFocus Tasks",
                      :type => "line",
                      :total => false,
                      :yAxis => {
                                  :minValue => 0,
                                  :maxValue => (max_value + 10 - (max_value % 10))
                                  },
                      :datasequences => Query.find_by_data_type("line")
                      }
          }.to_json
end
