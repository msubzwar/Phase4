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

ActiveRecord::Schema.define(version: 2020_04_22_174010) do

  create_table "assignments", force: :cascade do |t|
    t.integer "store_id", null: false
    t.integer "employee_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.integer "pay_grade_id"
    t.index ["employee_id"], name: "index_assignments_on_employee_id"
    t.index ["pay_grade_id"], name: "index_assignments_on_pay_grade_id"
    t.index ["store_id"], name: "index_assignments_on_store_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "ssn"
    t.date "date_of_birth"
    t.string "phone"
    t.string "role"
    t.boolean "active"
    t.string "username"
    t.string "password_digest"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pay_grade_rates", force: :cascade do |t|
    t.float "rate"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pay_grade_id"
    t.index ["pay_grade_id"], name: "index_pay_grade_rates_on_pay_grade_id"
  end

  create_table "pay_grades", force: :cascade do |t|
    t.string "level"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shift_jobs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shift_id_id"
    t.integer "job_id_id"
    t.integer "job_id"
    t.integer "shift_id"
    t.index ["job_id"], name: "index_shift_jobs_on_job_id"
    t.index ["job_id_id"], name: "index_shift_jobs_on_job_id_id"
    t.index ["shift_id"], name: "index_shift_jobs_on_shift_id"
    t.index ["shift_id_id"], name: "index_shift_jobs_on_shift_id_id"
  end

  create_table "shifts", force: :cascade do |t|
    t.integer "assignment_id"
    t.date "date"
    t.time "start_time"
    t.time "end_time"
    t.text "notes"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignment_id"], name: "index_shifts_on_assignment_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "phone"
    t.boolean "active"
  end

end
