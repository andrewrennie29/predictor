class AddSeasontoMatches < ActiveRecord::Migration
  def change
  add_column :matches, :season, :string
  end
end
