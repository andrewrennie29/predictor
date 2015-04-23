class UpdateMatchesAddForecast < ActiveRecord::Migration
  def change
  
  	add_column :matches, :forecast_hg, :integer
  	add_column :matches, :forecast_ag, :integer
  	add_column :matches, :forecast_homewin, :float
  	add_column :matches, :forecast_draw, :float
  	add_column :matches, :forecast_awaywin, :float
  	
  end
end
