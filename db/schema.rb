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

ActiveRecord::Schema.define(version: 20130913210405) do

  create_table "ads", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "externid"
    t.decimal  "price"
    t.string   "url"
    t.string   "externsource"
    t.datetime "createdAt"
    t.datetime "updatedAt"
    t.text     "address"
    t.string   "ownership"
    t.string   "state"
    t.string   "mapurl"
    t.string   "building_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "lastCheckAt"
    t.string   "lastCheckResponseStatus"
  end

  create_table "ads_requests", force: true do |t|
    t.integer "request_id"
    t.integer "ad_id"
  end

  create_table "requests", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "email"
    t.boolean  "processed",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "failedAttempts", default: 0
  end

  create_table "requests_search_infos", force: true do |t|
    t.integer "request_id"
    t.integer "search_info_id"
  end

  create_table "search_infos", force: true do |t|
    t.integer  "resultsCount",   default: 0
    t.datetime "lastCheckAt"
    t.string   "lastAdExternId"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
