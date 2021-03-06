class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
			t.string :Season
			t.string :Div
			t.string :Team
			t.integer :Pos
			t.integer :HPlayed
			t.integer :HFHT
			t.integer :HFFT
			t.integer :HAHT
			t.integer :HAFT
			t.integer :HHS
			t.integer :HAS
			t.integer :HHST
			t.integer :HAST
			t.integer :HWins
			t.integer :HDraws
			t.integer :HLosses
			t.integer :HPts
			t.integer :HPos
			t.integer :APlayed
			t.integer :AFHT
			t.integer :AFFT
			t.integer :AAHT
			t.integer :AAFT
			t.integer :AHS
			t.integer :AAS
			t.integer :AHST
			t.integer :AAST
			t.integer :AWins
			t.integer :ADraws
			t.integer :ALosses
			t.integer :APts
			t.integer :APos
      t.timestamps
    end
  end
end
