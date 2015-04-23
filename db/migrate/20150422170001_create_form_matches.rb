class CreateFormMatches < ActiveRecord::Migration
  def change
    create_table :form_matches do |t|
			t.string :team
			t.float :goalsfor
			t.float :goalsagainst
      t.timestamps
    end
  end
end
