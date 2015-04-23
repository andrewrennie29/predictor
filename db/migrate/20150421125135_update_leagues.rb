class UpdateLeagues < ActiveRecord::Migration
  def change
  
  rename_column :leagues, :Div, :div
  rename_column :leagues, :Season, :season
  rename_column :leagues, :HFHT, :games_played
  rename_column :leagues, :HFFT, :home_goals
  rename_column :leagues, :HAHT, :away_goals
  
  end
end
