class AddWeightedGoalsToMatches < ActiveRecord::Migration
  def change
  	
  	add_column :matches, :FTHG_W, :float
  	add_column :matches, :FTAG_W, :float
  
  end
end
