class MatchesController < ApplicationController

def importdata
	
	baseURL = 'http://football-data.co.uk/mmz4281/'
	season = params[:season]
	
	leagues = ['E0', 'E1', 'E2', 'E3', 'EC', 'SC0', 'SC1', 'SC2', 'SC3', 'D1', 'D2', 'I1', 'I2', 'SP1', 'SP2', 'F1', 'F2', ]
	
	leagues.each do |l|
	
		getresultsdata(baseURL + season + "/" + l + ".csv", season)
	
	end
	
	redirect_to createseason_path(:season => season)
	
end

def getresultsdata(url, season)
	
	require 'csv'
	require 'open-uri'
	
	Matches.where("season = ? and (FTHG is null or FTAG is null)", "20" + season).destroy_all
	
	fields_to_insert = %w{ Div	Date	HomeTeam	AwayTeam	FTHG	FTAG	HTHG	HTAG	HS	AS	HST	AST	HF	AF	HC	AC	HY	AY	HR	AR }

	csv_text = open(url).read()

	CSV.parse(csv_text, :headers => true).each do |row|
		match_data = row.to_hash
		
		match = Matches.where("Date = ? and HomeTeam = ? and AwayTeam = ?", Date.strptime(match_data["Date"],'%d/%m/%y'), match_data["HomeTeam"], match_data["AwayTeam"])
		
		if match.count==0
			
			row=row.to_hash.select { |k, v| fields_to_insert.include?(k) }
			
			row["Date"] = Date.strptime(row["Date"],'%d/%m/%y')
			
			match = Matches.create!(row.to_hash.select { |k, v| fields_to_insert.include?(k) })
			
			forecast = Fixtures.where("HomeTeam = ? and AwayTeam = ?", match.HomeTeam, match.AwayTeam).first
			
			Matches.update(match.id, :season => '20' + season, :forecast_hg => forecast.FTHG, :forecast_ag => forecast.FTAG, :forecast_homewin => forecast.home_win, :forecast_draw => forecast.draw, :forecast_awaywin => forecast.away_win)
			
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

def forecastmatch(hometeam, awayteam, season)
	
	#Add current form based on previous 6 matches
	#  Add currentformmatches model
	#  Populate model
	#  update hc and ac
	
	#Add promoted/relegated multipliers
	
	fixture = Fixtures.where("HomeTeam = ? and AwayTeam = ?", hometeam, awayteam).first
	
	ps = prevseason(season)

	hp = Teams.where("team = ? and season = ?", hometeam, ps)
	hc = FormMatches.where("team = ?", hometeam).first
	ap = Teams.where("team = ? and season = ?", awayteam, ps)
	ac = FormMatches.where("team = ?", awayteam).first
	bp = Teams.where("`div` = ? and season = ?", fixture.Div, ps)
	
	homestats = {"Atk" => (hp.sum(:hgf) + hp.sum(:agf)).to_f/(hp.sum(:hgp) + hp.sum(:agp)).to_f,
							"Def" => (hp.sum(:hga) + hp.sum(:aga)).to_f/(hp.sum(:hgp) + hp.sum(:agp)).to_f,
							"FormAtk" => hc.goalsfor.to_f,
							"FormDef" => hc.goalsagainst.to_f}
	
	awaystats = {"Atk" => (ap.sum(:hgf) + ap.sum(:agf)).to_f/(ap.sum(:hgp) + ap.sum(:agp)).to_f,
							"Def" => (ap.sum(:hga) + ap.sum(:aga)).to_f/(ap.sum(:hgp) + ap.sum(:agp)).to_f,
							"FormAtk" => ac.goalsfor.to_f,
							"FormDef" => ac.goalsagainst.to_f}
	
	basestats = {"Atk" => (bp.sum(:hgf) + bp.sum(:agf)).to_f/(bp.sum(:hgp) + bp.sum(:agp)).to_f,
							"Def" => (bp.sum(:hga) + bp.sum(:aga)).to_f/(bp.sum(:hgp) + bp.sum(:agp)).to_f,
							"HomeAdv" => (hp.sum(:hgf).to_f/hp.sum(:hgp).to_f)-(hp.sum(:agf).to_f/hp.sum(:agp).to_f)}
	
	h = Math.exp((homestats["Atk"] - basestats["Atk"]) + (homestats["FormAtk"] - homestats["Atk"]) + (awaystats["Def"] - basestats["Def"]) + (awaystats["FormDef"] - awaystats["Def"]) + basestats["HomeAdv"])
	a = Math.exp((awaystats["Atk"] - basestats["Atk"]) + (awaystats["FormAtk"] - awaystats["Atk"]) + (homestats["Def"] - basestats["Def"]) + (homestats["FormDef"] - homestats["Def"]))
	
	phg=[]
	pag=[]
	
	(0..9).each do |g|
	
		phg[g] = Distribution::Poisson.pdf(g,h)
		pag[g] = Distribution::Poisson.pdf(g,a)
		
	end
			
	phg[10] = 1-phg.inject(:+)
	pag[10] = 1-phg.inject(:+)
	
	homewin = 0.0
	draw = 0.0
	awaywin = 0.0
	
	(0..10).each do |ag|
		
		(0..10).each do |hg|
			
			if hg > ag
			
				homewin = homewin + phg[hg] * pag[ag]
			
			end
			
			if hg == ag
			
				draw = draw + phg[hg] * pag[ag]
			
			end
			
			if hg < ag
			
				awaywin = awaywin + phg[hg] * pag[ag]
			
			end
			
		end
		
	end
	
	Fixtures.update(fixture.id, :FTHG => phg.index(phg.compact.max), :FTAG => pag.index(pag.compact.max), :home_win => homewin, :draw => draw, :away_win => awaywin)
	
end

def prevseason(season)

	p = season.slice(0,2).to_i
	c = season.slice(2,2).to_i

	
	p=(p-1).to_s
	c=(c-1).to_s
	
	'20' + p + c
	
end

def forecastfixtures
	
	fixturesURL = 'http://www.football-data.co.uk/fixtures.csv'
	
	getfixturesdata(fixturesURL)
	
	fixtures = Fixtures.all
	
	fixtures.each do |f|
	
		forecastmatch(f.HomeTeam, f.AwayTeam, '1516')
	
	end

end

end
