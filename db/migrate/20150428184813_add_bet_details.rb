class AddBetDetails < ActiveRecord::Migration
  def change
  	add_column :fixtures, :bet_stake, :float
  	add_column :fixtures, :bet_odds, :float
  	add_column :matches, :bet_stake, :float
  	add_column :matches, :bet_odds, :float
  	add_column :matches, :bet_return, :float
  end
end
