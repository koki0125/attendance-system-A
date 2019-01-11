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

ActiveRecord::Schema.define(version: 20181227003854) do

  create_table "attendances", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "started_time"
    t.datetime "finished_time"
    t.date "attendance_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expected_finish_time"
    t.datetime "overtime"
    t.string "detail"
    t.string "reason"
    t.boolean "approval"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "department"
    t.string "remember_digest"
    t.boolean "admin", default: false, null: false
    t.time "basic_time"
    t.integer "employee_number"
    t.boolean "superior", default: false
    t.time "designated_start_time"
    t.time "designated_finish_time"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
