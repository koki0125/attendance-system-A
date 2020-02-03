ActiveRecord::Schema.define(version: 2020_02_03_230617) do

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
    t.datetime "modified_started_time"
    t.datetime "modified_finished_time"
    t.integer "status_modified", default: 0
    t.integer "status_overtime", default: 0
    t.integer "status_month", default: 0
    t.integer "superior_id_overtime"
    t.boolean "tomorrow", default: false
    t.integer "superior_id_month"
    t.integer "superior_id_modified"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bases", force: :cascade do |t|
    t.integer "base_number"
    t.string "base_name"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.integer "uid"
    t.integer "card_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
