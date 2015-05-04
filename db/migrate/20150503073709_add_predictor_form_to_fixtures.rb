class AddPredictorFormToFixtures < ActiveRecord::Migration
  def change
  
  add_column :fixtures, :phform, :integer
  add_column :fixtures, :phgames, :integer
  add_column :fixtures, :paform, :integer
  add_column :fixtures, :pagames, :integer
  
  end
end
