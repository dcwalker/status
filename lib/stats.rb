class Stats < ActiveRecord::Base
  has_many :stat_datas

  def as_json(options={})
    {
      :title => self.name,
      :refreshEveryNSeconds => "120",
      :color => self.color,
      :datapoints => StatData.find_averages_for_stat(self.id)
    }
  end

end
