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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130628192917) do

  create_table "allies", :force => true do |t|
    t.integer "player_id", :null => false
    t.integer "ally_id",   :null => false
  end

  create_table "games", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
  end

  create_table "hero_picks", :force => true do |t|
    t.integer "player_id", :null => false
    t.integer "hero_id",   :null => false
  end

  create_table "players", :force => true do |t|
    t.integer "game_id",                             :null => false
    t.integer "user_id",                             :null => false
    t.string  "phase",         :default => "joined", :null => false
    t.boolean "swapped_ally",  :default => false,    :null => false
    t.boolean "swapped_spell", :default => false,    :null => false
    t.integer "hero_id"
  end

  create_table "spells", :force => true do |t|
    t.integer "player_id", :null => false
    t.integer "spell_id",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username",           :null => false
    t.string   "email",              :null => false
    t.string   "encrypted_password", :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "token",              :null => false
  end

end
