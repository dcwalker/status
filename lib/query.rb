require 'yaml'
require 'active_record'

class Query < ActiveRecord::Base
  has_many :stat_datas

  def as_json(options={})
    {
      :title => self.name,
      :refreshEveryNSeconds => "120",
      :color => self.color,
      :datapoints => StatData.find_averages_for_query(self.id)
    }
  end

end
