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

ActiveRecord::Schema.define(version: 20131210103721) do

  create_table "orderers", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orderers", ["user_id"], name: "index_orderers_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

  create_table "works", force: true do |t|
    t.string   "title"
    t.decimal  "payment"
    t.text     "other"
    t.boolean  "finished",   default: false
    t.boolean  "claimed",    default: false
    t.boolean  "receipted",  default: false
    t.integer  "user_id"
    t.integer  "orderer_id", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "works", ["user_id", "created_at"], name: "index_works_on_user_id_and_created_at"

  create_table "worktimes", force: true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "memo"
    t.integer  "work_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "worktimes", ["work_id", "start_time"], name: "index_worktimes_on_work_id_and_user_id_and_start_time", unique: true

end
