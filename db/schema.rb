# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150504054657) do

  create_table "data_updates", force: true do |t|
    t.string   "url"
    t.string   "divisions"
    t.date     "lastupdated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "newdata"
  end

  create_table "fixtures", force: true do |t|
    t.string   "Div"
    t.date     "Date"
    t.string   "HomeTeam"
    t.string   "AwayTeam"
    t.integer  "FTHG"
    t.integer  "FTAG"
    t.integer  "HTHG"
    t.integer  "HTAG"
    t.integer  "HP"
    t.integer  "AP"
    t.integer  "HGoalsF"
    t.integer  "HGoalsA"
    t.integer  "HChancesF"
    t.integer  "HChancesA"
    t.integer  "HOnTargetF"
    t.integer  "HOnTargetA"
    t.integer  "HAtk"
    t.integer  "HDef"
    t.integer  "AGoalsF"
    t.integer  "AGoalsA"
    t.integer  "AChancesF"
    t.integer  "AChancesA"
    t.integer  "AOnTargetF"
    t.integer  "AOnTargetA"
    t.integer  "AAtk"
    t.integer  "ADef"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "home_win",   limit: 24
    t.float    "away_win",   limit: 24
    t.float    "draw",       limit: 24
    t.float    "bet_stake",  limit: 24
    t.float    "bet_odds",   limit: 24
    t.integer  "phform"
    t.integer  "phgames"
    t.integer  "paform"
    t.integer  "pagames"
  end

  create_table "form_matches", force: true do |t|
    t.string   "team"
    t.float    "goalsfor",     limit: 24
    t.float    "goalsagainst", limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leagues", force: true do |t|
    t.string   "season"
    t.string   "div"
    t.string   "Team"
    t.integer  "Pos"
    t.integer  "HPlayed"
    t.integer  "games_played"
    t.integer  "home_goals"
    t.integer  "away_goals"
    t.integer  "HAFT"
    t.integer  "HHS"
    t.integer  "HAS"
    t.integer  "HHST"
    t.integer  "HAST"
    t.integer  "HWins"
    t.integer  "HDraws"
    t.integer  "HLosses"
    t.integer  "HPts"
    t.integer  "HPos"
    t.integer  "APlayed"
    t.integer  "AFHT"
    t.integer  "AFFT"
    t.integer  "AAHT"
    t.integer  "AAFT"
    t.integer  "AHS"
    t.integer  "AAS"
    t.integer  "AHST"
    t.integer  "AAST"
    t.integer  "AWins"
    t.integer  "ADraws"
    t.integer  "ALosses"
    t.integer  "APts"
    t.integer  "APos"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", force: true do |t|
    t.string   "Div"
    t.date     "Date"
    t.string   "HomeTeam"
    t.string   "AwayTeam"
    t.string   "FTHG"
    t.string   "FTAG"
    t.string   "HTHG"
    t.string   "HTAG"
    t.string   "HS"
    t.string   "AS"
    t.string   "HST"
    t.string   "AST"
    t.string   "HF"
    t.string   "AF"
    t.string   "HC"
    t.string   "AC"
    t.string   "HY"
    t.string   "AY"
    t.string   "HR"
    t.string   "AR"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "season"
    t.integer  "forecast_hg"
    t.integer  "forecast_ag"
    t.float    "forecast_homewin",      limit: 24
    t.float    "forecast_draw",         limit: 24
    t.float    "forecast_awaywin",      limit: 24
    t.float    "FTHG_W",                limit: 24
    t.float    "FTAG_W",                limit: 24
    t.string   "result"
    t.string   "score_forecast_result"
    t.string   "perc_forecast_result"
    t.boolean  "correctscore"
    t.boolean  "correctresult"
    t.float    "bet_stake",             limit: 24
    t.float    "bet_odds",              limit: 24
    t.float    "bet_return",            limit: 24
  end

  create_table "pr_multipliers", force: true do |t|
    t.string   "season"
    t.string   "prev_div"
    t.integer  "prev_played"
    t.integer  "prev_for"
    t.integer  "prev_against"
    t.string   "curr_div"
    t.integer  "curr_played"
    t.integer  "curr_for"
    t.integer  "curr_against"
    t.float    "atk_mod",      limit: 24
    t.float    "def_mod",      limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: true do |t|
    t.string   "team"
    t.integer  "lastseasonposition"
    t.integer  "currentseasonposition"
    t.integer  "hgp"
    t.integer  "hgf"
    t.integer  "hga"
    t.integer  "total_shots_for"
    t.integer  "shots_for_on_target"
    t.integer  "total_shots_against"
    t.integer  "shots_against_on_target"
    t.integer  "wins"
    t.integer  "draws"
    t.integer  "losses"
    t.integer  "points"
    t.float    "strength",                    limit: 24
    t.integer  "avg_goals_for"
    t.integer  "avg_goals_against"
    t.integer  "avg_total_shots_for"
    t.integer  "avg_shots_for_on_target"
    t.integer  "avg_total_shots_against"
    t.integer  "avg_shots_against_on_target"
    t.integer  "avg_wins"
    t.integer  "avg_draws"
    t.integer  "avg_losses"
    t.integer  "avg_points"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "div"
    t.string   "season"
    t.integer  "agp"
    t.integer  "agf"
    t.integer  "aga"
    t.integer  "perfect_home"
    t.integer  "perfect_away"
    t.integer  "games_since_perfect"
  end

end
