class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
			t.string :team
			t.integer :lastseasonposition
			t.integer :currentseasonposition
			t.integer :games_played
			t.integer :goals_for
			t.integer :goals_against
			t.integer :total_shots_for
			t.integer :shots_for_on_target
			t.integer :total_shots_against
			t.integer :shots_against_on_target
			t.integer :wins
			t.integer :draws
			t.integer :losses
			t.integer :points
			t.float :strength
			t.integer :avg_goals_for
			t.integer :avg_goals_against
			t.integer :avg_total_shots_for
			t.integer :avg_shots_for_on_target
			t.integer :avg_total_shots_against
			t.integer :avg_shots_against_on_target
			t.integer :avg_wins
			t.integer :avg_draws
			t.integer :avg_losses
			t.integer :avg_points
      t.timestamps
    end
  end
end
