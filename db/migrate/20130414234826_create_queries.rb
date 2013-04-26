class CreateQueries < ActiveRecord::Migration
  def up
    create_table :queries do |t|
      t.string :name
      t.string :sql
      t.string :color
      t.string :data_type
      t.timestamps
    end
  end

  def down
    drop_table :query
  end
end