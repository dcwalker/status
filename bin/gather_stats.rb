#!/usr/bin/env ruby
require "sqlite3"
require "yaml"

require File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib", 'stats')
require File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib", 'stat_data')

db = SQLite3::Database.new "#{ENV['HOME']}/Library/Caches/com.omnigroup.OmniFocus/OmniFocusDatabase2"
Query = Struct.new(:name, :sql, :color)

queries = YAML.load_file(File.join(File.expand_path(File.dirname(__FILE__)), "..", "config", "queries.yml"))
coordinated_time = Time.now

queries.each do |query|
  stat = Stats.find_by_name query.name
  if stat.nil?
    stat = Stats.create(name: query.name, color: query.color)
  end
  db.execute( query.sql ) do |value|
    StatData.create(stats_id: stat.id, value: value.first.to_i, created_at: coordinated_time, updated_at: coordinated_time)
  end
end
