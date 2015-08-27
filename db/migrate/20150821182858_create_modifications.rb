class CreateModifications < ActiveRecord::Migration
  def change
    create_table :modifications do |t|
		t.datetime :date
		t.string :content
		t.references :Tracker, index: true

		t.timestamps null: false
    end
    add_foreign_key :modifications, :Trackers
  end
end
