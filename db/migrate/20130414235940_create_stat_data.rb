class CreateStatData < ActiveRecord::Migration
  def up
    create_table :stat_data do |t|
      t.integer :stats_id
      t.integer :value
      t.timestamps
    end
  end

  def down
      drop_table :stat_data
  end
end
