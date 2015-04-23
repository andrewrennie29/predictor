class FormMatchesController < ApplicationController

def getform

	teams = Teams.where("season = ?", '20' + params[:season])
	
	teams.each do |t|
	
		matches = Matches.where("season = ? and (HomeTeam = ? or AwayTeam = ?)", '20' + params[:season], t.team, t.team).order(Date: :desc).limit(6)
		
		gf = 0.0
		ga = 0.0
		
		matches.each do |m|
		
			if m.HomeTeam == t.team
			
				gf = gf + m.FTHG.to_f
				ga = ga + m.FTAG.to_f
				
			else
			
				gf = gf + m.FTAG.to_f
				ga = ga + m.FTHG.to_f
				
			end
		
		end
		
		gf = gf.to_f/matches.count
		ga = ga.to_f/matches.count
		
		fm = FormMatches.where('team = ?', t.team).first
	
		if fm.nil?
		
			FormMatches.create(:team => t.team, :goalsfor => gf, :goalsagainst => ga)
			
		else
		
			FormMatches.update(fm.id, :goalsfor => gf, :goalsagainst => ga)
			
		end
	
	end

end

end
