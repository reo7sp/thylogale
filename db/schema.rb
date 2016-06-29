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

ActiveRecord::Schema.define(version: 20160628224459) do

  create_table "first_setups", force: :cascade do |t|
    t.boolean  "done",                  default: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "import_choice"
    t.string   "save_choice"
    t.string   "save_s3_access_key"
    t.string   "save_s3_secret"
    t.string   "save_s3_region"
    t.string   "email_choice"
    t.string   "email_mailgun_api_key"
    t.string   "email_mailgun_domain"
    t.string   "save_local_dir"
    t.string   "site_domain"
  end

  create_table "page_folders", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "pages_count"
    t.integer  "root_folder_id"
    t.string   "name"
    t.string   "title"
    t.string   "path"
    t.string   "container"
    t.integer  "subdirectories_count"
  end

  add_index "page_folders", ["root_folder_id"], name: "index_page_folders_on_root_folder_id"

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.string   "name"
    t.string   "template"
    t.integer  "root_folder_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "path"
    t.string   "container"
  end

  add_index "pages", ["root_folder_id"], name: "index_pages_on_root_folder_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
