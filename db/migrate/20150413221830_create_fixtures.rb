class CreateFixtures < ActiveRecord::Migration
  def change
    create_table :fixtures do |t|
			t.string :Div	
			t.date :Date
			t.string :HomeTeam
			t.string :AwayTeam
			t.integer :FTHG
			t.integer :FTAG
			t.integer :HTHG
			t.integer :HTAG
			t.integer :HP
			t.integer :AP
			t.integer :HGoalsF
			t.integer :HGoalsA
			t.integer :HChancesF
			t.integer :HChancesA
			t.integer :HOnTargetF
			t.integer :HOnTargetA
			t.integer :HAtk
			t.integer :HDef
			t.integer :AGoalsF
			t.integer :AGoalsA
			t.integer :AChancesF
			t.integer :AChancesA
			t.integer :AOnTargetF
			t.integer :AOnTargetA
			t.integer :AAtk
			t.integer :ADef
      t.timestamps
    end
  end
end
