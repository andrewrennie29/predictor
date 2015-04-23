class UpdateTeams < ActiveRecord::Migration
  def change
  
  	rename_column :teams, :games_played, :hgp
  	rename_column :teams, :goals_for, :hgf
  	rename_column :teams, :goals_against, :hga
  	add_column :teams, :agp, :integer
  	add_column :teams, :agf, :integer
  	add_column :teams, :aga, :integer
  	
  end
end
