class AddUpdateReqdToImports < ActiveRecord::Migration
  def change
  
  	add_column :data_updates, :newdata, :boolean
  
  end
end
