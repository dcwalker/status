class StatData < ActiveRecord::Base
  belongs_to :stats

  def self.find_averages_for_stat(stat_id = nil)
    StatData.find_by_sql("SELECT
        distinct stats_id,
      AVG(value) as value,
        CONCAT(
            DATE(created_at), ' ',
            HOUR(created_at), ':',
            CASE
                WHEN MINUTE(created_at) BETWEEN  0 AND  9 THEN '00'
                WHEN MINUTE(created_at) BETWEEN 10 AND 19 THEN '10'
                WHEN MINUTE(created_at) BETWEEN 20 AND 29 THEN '20'
                WHEN MINUTE(created_at) BETWEEN 30 AND 39 THEN '30'
                WHEN MINUTE(created_at) BETWEEN 40 AND 49 THEN '40'
                WHEN MINUTE(created_at) BETWEEN 50 AND 59 THEN '50'
            END
        ) AS created_at
    FROM stat_data
    WHERE created_at >= '#{12.hours.ago}' and stats_id = ':stat_id'
    GROUP BY stats_id, created_at;", {:stat_id => stat_id})
  end

  def self.find_max_value
    StatData.find_by_sql("SELECT MAX(t.value) as value from ( SELECT
      AVG(value) as value,
        CONCAT(
            DATE(created_at), ' ',
            HOUR(created_at), ':',
            CASE
                WHEN MINUTE(created_at) BETWEEN  0 AND  9 THEN '00'
                WHEN MINUTE(created_at) BETWEEN 10 AND 19 THEN '10'
                WHEN MINUTE(created_at) BETWEEN 20 AND 29 THEN '20'
                WHEN MINUTE(created_at) BETWEEN 30 AND 39 THEN '30'
                WHEN MINUTE(created_at) BETWEEN 40 AND 49 THEN '40'
                WHEN MINUTE(created_at) BETWEEN 50 AND 59 THEN '50'
            END
        ) AS created_at
    FROM stat_data
    WHERE created_at >= '#{12.hours.ago}'
    GROUP BY created_at) as t;").first.value
  end

  def as_json(options={})
    {
      :title => self.created_at.strftime("%H:%M"),
      :value => self.value
    }
  end

end
