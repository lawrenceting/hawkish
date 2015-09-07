class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.string :content
      t.references :tracker, index: true

      t.timestamps null: false
    end
#    add_foreign_key :updates, :trackers
  end
end
