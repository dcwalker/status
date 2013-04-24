#!/usr/bin/env ruby
require File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib", 'stat_data')

StatData.where("created_at < :created_at", {:created_at => 1.month.ago}).destroy_all