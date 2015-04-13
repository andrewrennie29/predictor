class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
			t.string :div
			t.date :matchdate
			t.string :hometeam
			t.string :awayteam
			t.string :FTHG
			t.string :FTAG
			t.string :HTHG
			t.string :HTAG	
			t.string :HS
			t.string :AS
			t.string :HST
			t.string :AST
			t.string :HF
			t.string :AF
			t.string :HC
			t.string :AC
			t.string :HY
			t.string :AY
			t.string :HR
			t.string :AR
      t.timestamps
    end
  end
end
