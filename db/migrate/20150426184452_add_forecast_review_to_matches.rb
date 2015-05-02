class AddForecastReviewToMatches < ActiveRecord::Migration
  def change
  
  	add_column :matches, :result, :string
  	add_column :matches, :score_forecast_result, :string
  	add_column :matches, :perc_forecast_result, :string
  	add_column :matches, :correctscore, :boolean
  	add_column :matches, :correctresult, :boolean
  	
  end
end
