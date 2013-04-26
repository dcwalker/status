# encoding: UTF-8

require 'bundler'
Bundler.setup(:default, ENV['RACK_ENV'].to_sym)

require './status'
run Sinatra::Application
