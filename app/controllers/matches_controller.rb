class MatchesController < ApplicationController

def importdata
	
	@BaseURL = 'http://football-data.co.uk/mmz4281/'
	@Season = '1415'
	@FixturesURL = 'http://www.football-data.co.uk/fixtures.csv'
	
	getresultsdata(@BaseURL + @Season + "/" + "E0.csv")
	getresultsdata(@BaseURL + @Season + "/" + "E1.csv")
	getresultsdata(@BaseURL + @Season + "/" + "E2.csv")
	getresultsdata(@BaseURL + @Season + "/" + "E3.csv")
	getresultsdata(@BaseURL + @Season + "/" + "EC.csv")
	getresultsdata(@BaseURL + @Season + "/" + "SC0.csv")
	getresultsdata(@BaseURL + @Season + "/" + "SC1.csv")
	getresultsdata(@BaseURL + @Season + "/" + "SC2.csv")
	getresultsdata(@BaseURL + @Season + "/" + "SC3.csv")
	getresultsdata(@BaseURL + @Season + "/" + "D1.csv")
	getresultsdata(@BaseURL + @Season + "/" + "D2.csv")
	getresultsdata(@BaseURL + @Season + "/" + "I1.csv")
	getresultsdata(@BaseURL + @Season + "/" + "I2.csv")	
	getresultsdata(@BaseURL + @Season + "/" + "SP1.csv")
	getresultsdata(@BaseURL + @Season + "/" + "SP2.csv")
	getresultsdata(@BaseURL + @Season + "/" + "F1.csv")
	getresultsdata(@BaseURL + @Season + "/" + "F2.csv")
	
	getfixturesdata(@FixturesURL)
	
end

def getresultsdata(url)

	require 'csv'
	require 'open-uri'
	
	fields_to_insert = %w{ Div	Date	HomeTeam	AwayTeam	FTHG	FTAG	HTHG	HTAG	HS	AS	HST	AST	HF	AF	HC	AC	HY	AY	HR	AR }

	csv_text = open(url).read()

	CSV.parse(csv_text, :headers => true).each do |row|
		match_data = row.to_hash
		
		match = Matches.where("Date = ? and HomeTeam = ? and AwayTeam = ?", Date.strptime(match_data["Date"],'%d/%m/%y'), match_data["HomeTeam"], match_data["AwayTeam"])
		
		if match.count==0
			
			row=row.to_hash.select { |k, v| fields_to_insert.include?(k) }
			
			row["Date"] = Date.strptime(row["Date"],'%d/%m/%y')
			
			Matches.create!(row.to_hash.select { |k, v| fields_to_insert.include?(k) })
			
		end
		
	end
		
end

def getfixturesdata(url)

	require 'csv'
	require 'open-uri'
	
	fields_to_insert = %w{ Div	Date	HomeTeam	AwayTeam }

	csv_text = open(url).read()

	CSV.parse(csv_text, :headers => true).each do |row|
		fixture_data = row.to_hash
		
		fixture = Fixtures.where("Date = ? and HomeTeam = ? and AwayTeam = ?", Date.strptime(fixture_data["Date"],'%d/%m/%y'), fixture_data["HomeTeam"], fixture_data["AwayTeam"])
		
		if fixture.count==0
			
			row=row.to_hash.select { |k, v| fields_to_insert.include?(k) }
			
			row["Date"] = Date.strptime(row["Date"],'%d/%m/%y')
			
			Fixtures.create!(row.to_hash.select { |k, v| fields_to_insert.include?(k) })
			
		end
		
	end
		
end

end
