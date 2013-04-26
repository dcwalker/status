require './status'
require 'sinatra/activerecord/rake'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'yaml'
require 'active_record'
require File.join(File.expand_path(File.dirname(__FILE__)), "lib", 'query')

task :default => :spec

desc "Run all specs in spec directory (excluding plugin specs)"
RSpec::Core::RakeTask.new(:spec)

namespace :db do
  desc "Loads queries into database from config/query.yml file."
  task :load_queries do
    YAML.load_file(File.join(File.expand_path(File.dirname(__FILE__)), "config", "queries.yml")).each do |query|
      Query.where(:id => query[:id]).first_or_create.update_attributes(query)
    end
  end
end