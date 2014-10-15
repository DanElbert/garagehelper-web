class AddIsChangeToGarageUpdates < ActiveRecord::Migration
  def change
    add_column :garage_updates, :is_change, :boolean

    remove_index :garage_updates, :created_at
    add_index :garage_updates, [:created_at, :is_change]
  end
end
