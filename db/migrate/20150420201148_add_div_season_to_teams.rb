class AddDivSeasonToTeams < ActiveRecord::Migration
  def change
  	add_column :teams, :div, :string
  	add_column :teams, :season, :string
  end
end
