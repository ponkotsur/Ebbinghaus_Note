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

ActiveRecord::Schema.define(version: 20160622070420) do

  create_table "notebooks", force: :cascade do |t|
    t.string "guid",      limit: 255
    t.string "title",     limit: 255
    t.string "published", limit: 255
  end

  create_table "notes", force: :cascade do |t|
    t.string  "guid",              limit: 255
    t.string  "title",             limit: 255
    t.text    "content",           limit: 65535
    t.integer "contentLength",     limit: 4
    t.date    "created"
    t.date    "updated"
    t.string  "active",            limit: 255
    t.integer "updateSequenceNum", limit: 4
    t.string  "notebookGuid",      limit: 255
    t.integer "notebook_id",       limit: 4
  end

end
