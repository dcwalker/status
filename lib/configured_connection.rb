require 'active_record'

config = YAML.load_file(File.join(File.expand_path(File.dirname(__FILE__)), "..", "config", 'database.yml')
)

ActiveRecord::Base.establish_connection(
  adapter: config["adapter"],
  database: config["database"]
  )
