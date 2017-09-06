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

ActiveRecord::Schema.define(version: 20170124024300) do

  create_table "awards", force: :cascade do |t|
    t.integer "story_id"
    t.integer "user_id"
    t.integer "points",   default: 0
  end

  create_table "comments", force: :cascade do |t|
    t.text     "comment"
    t.integer  "user_id"
    t.integer  "story_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.date     "startdate"
    t.date     "estimatedenddate"
    t.integer  "security"
    t.string   "img_url"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "relation_user_projects", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relation_user_stories", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "story_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stories", force: :cascade do |t|
    t.string   "title"
    t.integer  "status"
    t.integer  "project_id"
    t.integer  "points"
    t.text     "description"
    t.integer  "story_type"
    t.integer  "award_began", default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "title"
    t.integer  "story_id"
    t.integer  "user_id"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email",                    null: false
    t.string   "password"
    t.integer  "gender",       default: 0, null: false
    t.date     "birthdate"
    t.integer  "role"
    t.string   "avatar_url"
    t.string   "activate_key"
    t.integer  "is_activate",  default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

end
