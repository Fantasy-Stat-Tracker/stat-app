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

ActiveRecord::Schema.define(version: 2020_05_28_013850) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.bigint "week_id"
    t.float "home_score"
    t.float "away_score"
    t.integer "home_id"
    t.integer "away_id"
    t.integer "winner_id"
    t.integer "loser_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "game_type"
    t.integer "year"
    t.integer "week_number"
    t.string "era", default: "espn"
    t.float "total_score"
    t.boolean "close"
    t.index ["week_id"], name: "index_games_on_week_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.integer "start_year"
    t.string "espn_s2"
    t.string "swid"
    t.integer "total_members_count"
    t.integer "active_members_count"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "member_seasons", force: :cascade do |t|
    t.bigint "member_id"
    t.bigint "season_id"
    t.boolean "is_winner"
    t.float "points"
    t.float "regular_season_points"
    t.float "playoff_points"
    t.integer "wins"
    t.integer "losses"
    t.integer "regular_season_wins"
    t.integer "regular_season_losses"
    t.integer "playoff_losses"
    t.integer "playoff_wins"
    t.integer "close_games"
    t.integer "close_wins"
    t.integer "close_losses"
    t.float "win_percentage"
    t.integer "year"
    t.float "points_per_game"
    t.string "espn_team_id"
    t.index ["member_id"], name: "index_member_seasons_on_member_id"
    t.index ["season_id"], name: "index_member_seasons_on_season_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.string "espn_id"
    t.bigint "league_id"
    t.bigint "user_id"
    t.string "team_name"
    t.index ["league_id"], name: "index_members_on_league_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.string "winner"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "league_id"
    t.index ["league_id"], name: "index_seasons_on_league_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "weeks", force: :cascade do |t|
    t.integer "number"
    t.bigint "season_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["season_id"], name: "index_weeks_on_season_id"
  end

  add_foreign_key "games", "weeks"
  add_foreign_key "member_seasons", "members"
  add_foreign_key "member_seasons", "seasons"
  add_foreign_key "members", "leagues"
  add_foreign_key "members", "users"
  add_foreign_key "seasons", "leagues"
  add_foreign_key "weeks", "seasons"
end
