class MatchesController < ApplicationController

	def importdata

		baseURL = 'http://football-data.co.uk/mmz4281/'
		season = params[:season]
	
		#leagues = ['N1','EC']
	
		leagues = ['E0', 'E1', 'E2', 'E3', 'EC', 'SC0', 'SC1', 'SC2', 'SC3', 'D1', 'D2', 'I1', 'I2', 'SP1', 'SP2', 'F1', 'F2', 'N1' ]

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
				
				hometeam = Teams.where('team = ? and season = ?', match.HomeTeam, prevseason(season)).first
				awayteam = Teams.where('team = ? and season = ?', match.AwayTeam, prevseason(season)).first
			
				if hometeam.nil?
			
					hc = 1
				
				else
			
					hc = (hometeam.hga + hometeam.aga).to_f / (hometeam.hgp + hometeam.agp).to_f

					if hometeam.div != match.Div
			
						hmulti = prmultiplier(hometeam.div, match.Div, season)
				
						hc = hc + hmulti["Def"]
				
					end
			
				end
			
				if awayteam.nil?
			
					ac = 1
				
				else
			
					ac = (awayteam.hga + awayteam.aga).to_f / (awayteam.hgp + awayteam.agp).to_f
			
					if awayteam.div != match.Div
			
						amulti = prmultiplier(awayteam.div, match.Div, season)
			
						ac = ac + amulti["Def"]
			
					end

				end
							
				whg = match.FTHG.to_f / ac
				wag = match.FTAG.to_f / hc
			
				forecast = Fixtures.where("Date = ? and HomeTeam = ? and AwayTeam = ?", match.Date, match.HomeTeam, match.AwayTeam).first
		
				if !forecast.nil?
				
					if forecast.FTHG == match.FTHG && forecast.FTHG == match.FTAG
				
						forecastscore = true
						
						betstake = forecast.bet_stake.to_f
						betodds = forecast.bet_odds.to_f
						
						unless betstake.nil?
						
							betreturn = betstake * betodds + betstake
						
						end
						
					else
				
						forecastscore = false
					
						unless forecast.bet_stake.nil?
						
							betreturn = 0
						
						end
					
					end
				
					Matches.update(match.id, :season => '20' + season, :forecast_hg => forecast.FTHG, :forecast_ag => forecast.FTAG, :forecast_homewin => forecast.home_win, :forecast_draw => forecast.draw, :forecast_awaywin => forecast.away_win, :FTHG_W => whg, :FTAG_W => wag, :correctscore => forecastscore, :bet_stake => betstake, :bet_odds => betodds, :bet_return => betreturn)
				
					forecast.destroy
				
				else
			
					Matches.update(match.id, :season => '20' + season, :FTHG_W => whg, :FTAG_W => wag)
		
				end
		
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
	
			match = Matches.where("Date = ? and HomeTeam = ? and AwayTeam = ?", Date.strptime(fixture_data["Date"],'%d/%m/%y'), fixture_data["HomeTeam"], fixture_data["AwayTeam"])
	
			if fixture.count==0 && match.count == 0
		
				row=row.to_hash.select { |k, v| fields_to_insert.include?(k) }
		
				row["Date"] = Date.strptime(row["Date"],'%d/%m/%y')
		
				Fixtures.create!(row.to_hash.select { |k, v| fields_to_insert.include?(k) })
		
			end
	
		end
	
	end

	def forecastmatch(hometeam, awayteam, season, date)

		fixture = Fixtures.where("HomeTeam = ? and AwayTeam = ? and Date = ?", hometeam, awayteam, date).first
	
		if fixture.nil?
	
			match = Matches.where("HomeTeam = ? and AwayTeam = ? and Date = ?", hometeam, awayteam, date).first
	
		end
	
		ps = prevseason(season)

		hp = Teams.where("team = ? and season = ?", hometeam, ps)
		hc = Matches.where("Date < ? and (HomeTeam = ? or AwayTeam = ?)", date, hometeam, hometeam).order(date: :desc).limit(6)
		ap = Teams.where("team = ? and season = ?", awayteam, ps)
		ac = Matches.where("Date < ? and (HomeTeam = ? or AwayTeam = ?)", date, awayteam, awayteam).order(date: :desc).limit(6)
	
		if hp.first.nil?
		
			hp = Teams.where("team = ? and season != ?", hometeam, ps).order(season: :desc)
	
		end
	
		if ap.first.nil?
		
			ap = Teams.where("team = ? and season != ?", awayteam, ps).order(season: :desc)
	
		end
	
	
		if fixture.nil?
	
			fixturediv = match.Div
		
		else
	
			fixturediv = fixture.Div
	
		end
	
		bp = Teams.where("`div` = ? and season = ?", fixturediv, ps)
	
		form = {"Home" => {"Atk" => 0.0, "Def" => 0.0}, "Away" => {"Atk" => 0.0, "Def" => 0.0}} 
	
		hcm = hc.count
	
		hc.each do |f|
	
			if f.HomeTeam == hometeam
		
				form["Home"]["Atk"] = form["Home"]["Atk"] + f.FTHG.to_f / hcm
				form["Home"]["Def"] = form["Home"]["Def"] + f.FTAG.to_f / hcm
		
			else
		
				form["Home"]["Def"] = form["Home"]["Def"] + f.FTHG.to_f / hcm
				form["Home"]["Atk"] = form["Home"]["Atk"] + f.FTAG.to_f / hcm
		
			end
		
		end
	
		acm = ac.count
	
		ac.each do |f|
	
			if f.HomeTeam == awayteam
		
				form["Away"]["Atk"] = form["Away"]["Atk"] + f.FTHG.to_f / acm
				form["Away"]["Def"] = form["Away"]["Def"] + f.FTAG.to_f / acm
		
			else
		
				form["Away"]["Def"] = form["Away"]["Def"] + f.FTHG.to_f / acm
				form["Away"]["Atk"] = form["Away"]["Atk"] + f.FTAG.to_f / acm
		
			end
		
		end
		
		if hp.count>0 && ap.count>0

			hprmulti = prmultiplier(hp.first.div, fixturediv, season)
			aprmulti = prmultiplier(ap.first.div, fixturediv, season)

			homestats = {"Atk" => ((hp.sum(:hgf) + hp.sum(:agf)).to_f / (hp.sum(:hgp) + hp.sum(:agp)).to_f) + hprmulti["Atk"].to_f,
									"Def" => ((hp.sum(:hga) + hp.sum(:aga)).to_f / (hp.sum(:hgp) + hp.sum(:agp)).to_f) + hprmulti["Def"].to_f,
									"FormAtk" => form["Home"]["Atk"],
									"FormDef" => form["Home"]["Def"]}

			awaystats = {"Atk" => ((ap.sum(:hgf) + ap.sum(:agf)).to_f / (ap.sum(:hgp) + ap.sum(:agp)).to_f) + aprmulti["Atk"].to_f,
									"Def" => ((ap.sum(:hga) + ap.sum(:aga)).to_f / (ap.sum(:hgp) + ap.sum(:agp)).to_f) + aprmulti["Def"].to_f,
									"FormAtk" => form["Away"]["Atk"],
									"FormDef" => form["Away"]["Def"]}

			basestats = {"Atk" => (bp.sum(:hgf) + bp.sum(:agf)).to_f/(bp.sum(:hgp) + bp.sum(:agp)).to_f,"Def" => (bp.sum(:hga) + bp.sum(:aga)).to_f/(bp.sum(:hgp) + bp.sum(:agp)).to_f,"HomeAdv" => (bp.sum(:hgf).to_f/bp.sum(:hgp).to_f)-(bp.sum(:agf).to_f/bp.sum(:agp).to_f)}

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
		
			if fixture.nil?
			
				if phg.index(phg.compact.max).to_i == match.FTHG.to_i && pag.index(pag.compact.max).to_i == match.FTAG.to_i
			
					perfectscore = true
				
				else
			
					perfectscore = false
					
				end
			
				Matches.update(match.id, :forecast_hg => phg.index(phg.compact.max), :forecast_ag => pag.index(pag.compact.max), :forecast_homewin => homewin, :forecast_draw => draw, :forecast_awaywin => awaywin, :correctscore => perfectscore)
			
			else
		
				Fixtures.update(fixture.id, :FTHG => phg.index(phg.compact.max), :FTAG => pag.index(pag.compact.max), :home_win => homewin, :draw => draw, :away_win => awaywin)

			end

		end

	end

	def prevseason(season)

		p = season.slice(0,2).to_i
		c = season.slice(2,2).to_i


		p=(p-1).to_s.rjust(2,'0')
		c=(c-1).to_s.rjust(2,'0')
		
		'20' + p + c

	end

	def forecastfixtures

		fixturesURL = 'http://www.football-data.co.uk/fixtures.csv'

		getfixturesdata(fixturesURL)

		fixtures = Fixtures.all

		fixtures.each do |f|

			forecastmatch(f.HomeTeam, f.AwayTeam, '1415', f.Date)

		end
	
		@fixtures = Fixtures.all.order(:Date, :Div, :HomeTeam)
		
		@teams = Teams.all
		
	end

	def forecastseason
		
		seasons = ['0607','0708','0809','0910','1011','1112','1213','1314','1415']
	
		seasons.each do |s|
	
		fixtures = Matches.where('(forecast_hg is null or forecast_ag is null) and season = ?', '20' + s).order(:HomeTeam, :AwayTeam, :Date)
		
			fixtures.each do |f|

				forecastmatch(f.HomeTeam, f.AwayTeam, s, f.Date)

			end
	
		end
	
	end

	def prmultiplier(prev_div, curr_div, season)

		if prev_div == curr_div || prev_div.nil?

			value = {"Atk" => 0.0, "Def" => 0.0}
	
		else

			prm = PrMultiplier.where('prev_div = ? and curr_div = ? and season = ?', prev_div, curr_div, '20' + season).first
		
			if prm.nil?
		
				value = {"Atk" => 0.0, "Def" => 0.0}
			
			else
		
				value = {"Atk" => prm.prev_for.to_f / prm.prev_played - prm.curr_for.to_f / prm.prev_played, "Def" => prm.prev_against.to_f / prm.prev_played - prm.curr_against.to_f / prm.prev_played}
		
			end
		
		end

		return value

	end

end
