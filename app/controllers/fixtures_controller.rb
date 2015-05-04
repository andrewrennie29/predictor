class FixturesController < ApplicationController

	def recordbet
	
		@fixture = Fixtures.find_by_id(params[:id])
	
	end

	def view
	
		@fixtures = Fixtures.all.order(:date, :div, :hometeam)
		@teams = Teams.all
		
	end
	
	def updatebet
	
		Fixtures.update(params[:fixtures][:id], :bet_odds => params[:fixtures][:bet_odds], :bet_stake => params[:fixtures][:bet_stake])
		
		redirect_to viewforecast_path
		
	end
	
end
