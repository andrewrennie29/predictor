class Renamematchescolumns < ActiveRecord::Migration
  def change

  rename_column :matches, :div, :Div
  rename_column :matches, :matchdate, :Date
  rename_column :matches, :hometeam, :HomeTeam
  rename_column :matches, :awayteam, :AwayTeam
  
  end
end
