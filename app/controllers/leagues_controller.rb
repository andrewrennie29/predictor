class LeaguesController < ApplicationController

def createseason

	leagues=Matches.where('season = ?', '20' + params[:season]).group("season, `div`")
	
	leagues.each do |l|
	
		@league=Leagues.where('season = ? and `div` = ?', l.season, l.Div).first
	
		if @league.nil?
			
			@league=Leagues.create(:season => l.season, :div => l.Div)
			
			@matches = Matches.where('Season = ? and `Div` = ?', '20' + params[:season], l.Div)
			Leagues.update(@league.id, 
										:games_played => @matches.count,
										:home_goals => @matches.sum(:FTHG), 
										:away_goals => @matches.sum(:FTAG))
			
		else
			
			@matches = Matches.where('season = ? and `div` = ?', '20' + params[:season], l.Div)
			Leagues.update(@league.id, 
										:games_played => @matches.count,
										:home_goals => @matches.sum(:FTHG), 
										:away_goals => @matches.sum(:FTAG))
		
		end
		
	end

end

def runfullseason

	

end



end
