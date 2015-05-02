class CreatePrMultipliers < ActiveRecord::Migration
  def change
    create_table :pr_multipliers do |t|
			t.string :season
			t.string :prev_div
			t.integer :prev_played
			t.integer :prev_for
			t.integer :prev_against
			t.string :curr_div
			t.integer :curr_played
			t.integer :curr_for
			t.integer :curr_against
			t.float :atk_mod
			t.float :def_mod
      t.timestamps
    end
  end
end
