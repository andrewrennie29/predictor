class TeamsController < ApplicationController

def createseason

	teams=Matches.where('season = ?', '20' + params[:season]).group("season, `Div`, `HomeTeam`")
	
	teams.each do |t|
	
		@team=Teams.where('season = ? and `div` = ? and team = ?', t.season, t.Div, t.HomeTeam).first
	
		if @team.nil?
			
			@team=Teams.create(:season => t.season, :div => t.Div, :team => t.HomeTeam)
			
			@matches = Matches.where('season = ? and (HomeTeam = ? or AwayTeam = ?)', '20' + params[:season], t.HomeTeam, t.HomeTeam)
			Teams.update(@team.id, 
										:hgp => @matches.where('HomeTeam = ?', @team.team).count,
										:agp => @matches.where('AwayTeam = ?', @team.team).count, 
										:hgf => @matches.where('HomeTeam = ?', @team.team).sum(:FTHG), 
										:agf => @matches.where('AwayTeam = ?', @team.team).sum(:FTAG), 
										:hga => @matches.where('HomeTeam = ?', @team.team).sum(:FTAG), 
										:aga => @matches.where('AwayTeam = ?', @team.team).sum(:FTHG))
			
		else
			
			@matches = Matches.where('season = ? and (HomeTeam = ? or AwayTeam = ?)', '20' + params[:season], t.HomeTeam, t.HomeTeam)
			Teams.update(@team.id, 
										:hgp => @matches.where('HomeTeam = ?', @team.team).count,
										:agp => @matches.where('AwayTeam = ?', @team.team).count, 
										:hgf => @matches.where('HomeTeam = ?', @team.team).sum(:FTHG), 
										:agf => @matches.where('AwayTeam = ?', @team.team).sum(:FTAG), 
										:hga => @matches.where('HomeTeam = ?', @team.team).sum(:FTAG), 
										:aga => @matches.where('AwayTeam = ?', @team.team).sum(:FTHG))
		
		end
		
	end
	
	redirect_to createleagues_path(:season => params[:season])
	
end

end
