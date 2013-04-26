require 'active_record'

class StatData < ActiveRecord::Base
  belongs_to :query

  def self.find_averages_for_query(query_id)
    StatData.find_by_sql(["SELECT
        distinct query_id,
      AVG(value) as value,
          (CASE
              WHEN CAST(strftime('%M', created_at) as integer) BETWEEN 0  AND 9 THEN strftime('%Y-%m-%d %H:00', created_at)
              WHEN CAST(strftime('%M', created_at) as integer) BETWEEN 10 AND 19 THEN strftime('%Y-%m-%d %H:10', created_at)
              WHEN CAST(strftime('%M', created_at) as integer) BETWEEN 20 AND 29 THEN strftime('%Y-%m-%d %H:20', created_at)
              WHEN CAST(strftime('%M', created_at) as integer) BETWEEN 30 AND 39 THEN strftime('%Y-%m-%d %H:30', created_at)
              WHEN CAST(strftime('%M', created_at) as integer) BETWEEN 40 AND 49 THEN strftime('%Y-%m-%d %H:40', created_at)
              WHEN CAST(strftime('%M', created_at) as integer) BETWEEN 50 AND 59 THEN strftime('%Y-%m-%d %H:50', created_at)
          END) as created_at,
		created_at as updated_at
    FROM stat_data
    WHERE created_at >= '#{12.hours.ago}' AND query_id = :id
    GROUP BY query_id, created_at", {:id => query_id}])
  end

  def self.find_max_value
    StatData.find_by_sql("SELECT MAX(t.value) as value from (SELECT
        distinct query_id,
      AVG(value) as value,
          (CASE
              WHEN CAST(strftime('%M', created_at) as integer) BETWEEN 0  AND 9 THEN strftime('%Y-%m-%d %H:00', created_at)
              WHEN CAST(strftime('%M', created_at) as integer) BETWEEN 10 AND 19 THEN strftime('%Y-%m-%d %H:10', created_at)
              WHEN CAST(strftime('%M', created_at) as integer) BETWEEN 20 AND 29 THEN strftime('%Y-%m-%d %H:20', created_at)
              WHEN CAST(strftime('%M', created_at) as integer) BETWEEN 30 AND 39 THEN strftime('%Y-%m-%d %H:30', created_at)
              WHEN CAST(strftime('%M', created_at) as integer) BETWEEN 40 AND 49 THEN strftime('%Y-%m-%d %H:40', created_at)
              WHEN CAST(strftime('%M', created_at) as integer) BETWEEN 50 AND 59 THEN strftime('%Y-%m-%d %H:50', created_at)
          END) as created_at,
		created_at as updated_at
    FROM stat_data
    WHERE created_at >= '#{12.hours.ago}'
    GROUP BY query_id, created_at) as t;").first.value
  end

  def as_json(options={})
    {
      :title => self.created_at.strftime("%H:%M"),
      :value => self.value
    }
  end

end
