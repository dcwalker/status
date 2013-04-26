#!/usr/bin/env ruby
require "sqlite3"
require "yaml"

require File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib", 'configured_connection')
require File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib", 'stat_data')
require File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib", 'query')

db = SQLite3::Database.new "#{ENV['HOME']}/Library/Caches/com.omnigroup.OmniFocus/OmniFocusDatabase2"

queries = Query.find_all_by_type( "count" )

queries.each do |query|
  db.execute( query.sql ) do |value|
    StatData.create(query_id: query.id, value: value.first.to_i)
  end
end
