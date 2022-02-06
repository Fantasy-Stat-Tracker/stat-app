# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_06_145001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "games", "weeks"
  add_foreign_key "member_seasons", "members"
  add_foreign_key "member_seasons", "seasons"
  add_foreign_key "members", "leagues"
  add_foreign_key "members", "users"
  add_foreign_key "seasons", "leagues"
  add_foreign_key "weeks", "seasons"
end
