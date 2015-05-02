class AddOutcomesToTeams < ActiveRecord::Migration
  def change
  
  add_column :teams, :perfect_home, :integer
  add_column :teams, :perfect_away, :integer
  add_column :teams, :games_since_perfect, :integer
  
  end
end
