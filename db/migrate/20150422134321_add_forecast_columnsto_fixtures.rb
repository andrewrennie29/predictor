class AddForecastColumnstoFixtures < ActiveRecord::Migration
  def change
  	
  	add_column :fixtures, :home_win, :float
  	add_column :fixtures, :away_win, :float
  	add_column :fixtures, :draw, :float
  
  end
end
