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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110901041556) do

  create_table "challenge_data", :force => true do |t|
    t.integer "challenge_id"
    t.string  "key",          :limit => 32
    t.string  "value"
  end

  create_table "challenge_responses", :force => true do |t|
    t.integer  "challenge_id"
    t.string   "response"
    t.string   "status",       :limit => 16, :default => "pending", :null => false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "challenge_templates", :force => true do |t|
    t.string "template_id",         :limit => 64
    t.string "display_text",        :limit => 128
    t.string "challenge_type",      :limit => 16
    t.string "challenge_subtype",   :limit => 16
    t.string "template_expression"
    t.string "game_filter",         :limit => 64
    t.string "team_filter",         :limit => 64
    t.string "player_filter",       :limit => 64
    t.string "picks",               :limit => 64
  end

  create_table "challenges", :force => true do |t|
    t.string   "stakes"
    t.integer  "user_id"
    t.string   "template_id",          :limit => 16
    t.string   "challenge_type",       :limit => 16
    t.string   "challenge_subtype",    :limit => 16
    t.string   "challenge_expression"
    t.string   "result",               :limit => 32
    t.integer  "sponsor_id"
    t.integer  "game_id"
    t.string   "player_filter",        :limit => 64
    t.string   "player1_id"
    t.string   "player2_id"
    t.string   "picks",                :limit => 64
    t.boolean  "public",                             :default => true,  :null => false
    t.boolean  "featured",                           :default => false, :null => false
    t.string   "status",               :limit => 16
    t.datetime "closes_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "challenge_id"
    t.integer  "user_id"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_stats", :force => true do |t|
    t.integer "game_id",                                        :null => false
    t.integer "week_id",            :limit => 4,                :null => false
    t.integer "team_id",                                        :null => false
    t.integer "points_scored",      :limit => 4, :default => 0, :null => false
    t.integer "points_allowed",     :limit => 4, :default => 0, :null => false
    t.integer "touchdowns",         :limit => 4, :default => 0, :null => false
    t.integer "rushing_attempts",   :limit => 4, :default => 0, :null => false
    t.integer "rushing_yards",                   :default => 0, :null => false
    t.integer "rushing_touchdowns",              :default => 0, :null => false
    t.integer "passing_attempts",   :limit => 4, :default => 0, :null => false
    t.integer "completed_passes",   :limit => 4, :default => 0, :null => false
    t.integer "passing_yards",                   :default => 0, :null => false
    t.integer "passing_touchdowns",              :default => 0, :null => false
    t.integer "turnovers",          :limit => 4, :default => 0, :null => false
    t.integer "interceptions",      :limit => 4, :default => 0, :null => false
    t.integer "fumbles_forced",     :limit => 4, :default => 0, :null => false
    t.integer "sacks",              :limit => 4, :default => 0, :null => false
    t.integer "punts",              :limit => 4, :default => 0, :null => false
  end

  create_table "games", :force => true do |t|
    t.integer  "game_id",      :null => false
    t.integer  "home_team_id", :null => false
    t.integer  "away_team_id", :null => false
    t.datetime "starts_at",    :null => false
  end

  create_table "player_stats", :force => true do |t|
    t.string  "player_id",            :limit => 32,                :null => false
    t.integer "game_id",                                           :null => false
    t.integer "week_id",              :limit => 4,                 :null => false
    t.integer "catches",              :limit => 4,  :default => 0, :null => false
    t.integer "touchdowns",           :limit => 4,  :default => 0, :null => false
    t.integer "sacks",                :limit => 4,  :default => 0, :null => false
    t.integer "times_sacked",         :limit => 4,  :default => 0, :null => false
    t.integer "interceptions",        :limit => 4,  :default => 0, :null => false
    t.integer "interceptions_thrown", :limit => 4,  :default => 0, :null => false
    t.integer "fumbles",              :limit => 4,  :default => 0, :null => false
    t.integer "fumbles_forced",       :limit => 4,  :default => 0, :null => false
    t.integer "rushing_attempts",     :limit => 4,  :default => 0, :null => false
    t.integer "rushing_yards",                      :default => 0, :null => false
    t.integer "rushing_touchdowns",                 :default => 0, :null => false
    t.integer "passing_attempts",     :limit => 4,  :default => 0, :null => false
    t.integer "completed_passes",     :limit => 4,  :default => 0, :null => false
    t.integer "passing_yards",                      :default => 0, :null => false
    t.integer "passing_touchdowns",                 :default => 0, :null => false
    t.integer "receiving_yards",                    :default => 0, :null => false
    t.integer "receiving_touchdowns",               :default => 0, :null => false
    t.integer "yards_after_catch",                  :default => 0, :null => false
  end

  create_table "players", :force => true do |t|
    t.string  "player_id", :limit => 32,                   :null => false
    t.integer "team_id",                                   :null => false
    t.string  "first",     :limit => 64,                   :null => false
    t.string  "last",                                      :null => false
    t.string  "position",  :limit => 64,                   :null => false
    t.integer "number",    :limit => 3,                    :null => false
    t.boolean "status",                  :default => true, :null => false
  end

  create_table "sponsors", :force => true do |t|
    t.string "name",  :limit => 80,  :null => false
    t.string "url",   :limit => 250, :null => false
    t.string "logo",  :limit => 250, :null => false
    t.string "intro"
  end

  create_table "stats_logs", :force => true do |t|
    t.string   "status",     :limit => 16, :default => "pending", :null => false
    t.integer  "week_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.integer "team_id", :limit => 64, :null => false
    t.string  "name",    :limit => 64, :null => false
    t.string  "city",    :limit => 64, :null => false
    t.string  "abbr",    :limit => 5,  :null => false
    t.string  "stadium", :limit => 64, :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "fb_number",  :limit => 24,                      :null => false
    t.string   "fb_token",   :limit => 180,                     :null => false
    t.integer  "clearance",  :limit => 8,                       :null => false
    t.string   "email"
    t.string   "nickname",   :limit => 64
    t.string   "role",       :limit => 16,  :default => "user", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "email_idx"
  add_index "users", ["fb_number"], :name => "fb_id_idx"

end
