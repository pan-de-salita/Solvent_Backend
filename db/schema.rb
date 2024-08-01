# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_08_01_040716) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "solution_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["solution_id", "user_id"], name: "index_comments_on_solution_id_and_user_id"
    t.index ["solution_id"], name: "index_comments_on_solution_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "version"
    t.index ["name"], name: "index_languages_on_name", unique: true
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "solution_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["solution_id"], name: "index_likes_on_solution_id"
    t.index ["user_id", "solution_id"], name: "index_likes_on_user_id_and_solution_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "puzzle_favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "puzzle_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["puzzle_id"], name: "index_puzzle_favorites_on_puzzle_id"
    t.index ["user_id", "puzzle_id"], name: "index_puzzle_favorites_on_user_id_and_puzzle_id", unique: true
    t.index ["user_id"], name: "index_puzzle_favorites_on_user_id"
  end

  create_table "puzzles", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "creator_id", null: false
    t.string "tags", default: [], array: true
    t.text "expected_output", null: false
    t.index ["creator_id"], name: "index_puzzles_on_creator_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.bigint "follower_id", null: false
    t.bigint "followed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "solutions", force: :cascade do |t|
    t.text "source_code", default: "", null: false
    t.bigint "language_id", null: false
    t.bigint "puzzle_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_solutions_on_language_id"
    t.index ["puzzle_id"], name: "index_solutions_on_puzzle_id"
    t.index ["user_id", "puzzle_id"], name: "index_solutions_on_user_id_and_puzzle_id"
    t.index ["user_id"], name: "index_solutions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.string "username", null: false
    t.integer "preferred_languages", default: [], array: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "comments", "solutions"
  add_foreign_key "comments", "users"
  add_foreign_key "likes", "solutions"
  add_foreign_key "likes", "users"
  add_foreign_key "puzzle_favorites", "puzzles"
  add_foreign_key "puzzle_favorites", "users"
  add_foreign_key "puzzles", "users", column: "creator_id"
  add_foreign_key "relationships", "users", column: "followed_id"
  add_foreign_key "relationships", "users", column: "follower_id"
  add_foreign_key "solutions", "languages"
  add_foreign_key "solutions", "puzzles"
  add_foreign_key "solutions", "users"
end
