class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
		t.string :url
		t.string :nodes
		t.string :content
		t.timestamps null: false
    end
  end
end
