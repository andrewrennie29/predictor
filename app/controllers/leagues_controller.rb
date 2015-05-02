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
	
	teams = Teams.where('season = ?', '20' + ((params[:season].slice(0,2).to_i)-1).to_s + ((params[:season].slice(2,2).to_i)-1).to_s)
	
	PrMultiplier.where('season = ?', '20' + params[:season]).update_all(:prev_played => 0, :prev_for => 0, :prev_against => 0, :curr_played => 0, :curr_for => 0, :curr_against => 0)
	
	teams.each do |c|
	
		p = Teams.where('team = ? and season = ?', c.team, '20' + ((params[:season].slice(0,2).to_i)-2).to_s + ((params[:season].slice(2,2).to_i)-2).to_s).first
		
		unless p.nil?
		
			unless c.div == p.div
		
				m = PrMultiplier.where('season = ? and prev_div = ? and curr_div = ?', '20' + params[:season], p.div, c.div).first
			
				if m.nil?
			
					m = PrMultiplier.create(:prev_div => p.div, :curr_div => c.div, :season => '20' + params[:season], :prev_played => 0, :prev_for => 0, :prev_against => 0, :curr_played => 0, :curr_for => 0, :curr_against => 0)
				
				end
			
				PrMultiplier.update(m.id,
														:prev_played => m.prev_played + p.hgp + p.agp, 
														:prev_for => m.prev_played + p.hgf + p.agf, 
														:prev_against => m.prev_played + p.hga + p.aga, 
														:curr_played => m.curr_played + c.hgp + c.agp, 
														:curr_for => m.curr_played + c.hgf + c.agf, 
														:curr_against => m.curr_played + c.hga + c.aga)
			
			end
		
		end
		
	end
	
	redirect_to getform_path(:season => season)
	
end

def runfullseason

	

end



end
