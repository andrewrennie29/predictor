class CreateDataUpdates < ActiveRecord::Migration
  def change
    create_table :data_updates do |t|
			t.string :url
			t.string :divisions
			t.date :lastupdated
      t.timestamps
    end
  end
end
