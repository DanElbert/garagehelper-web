class CreateGarageUpdates < ActiveRecord::Migration
  def change
    create_table :garage_updates do |t|

      t.boolean :big_door_open
      t.boolean :back_door_open
      t.boolean :basement_door_open

      t.timestamps
    end

    add_index :garage_updates, :created_at
  end
end
