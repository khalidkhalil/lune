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

ActiveRecord::Schema[7.0].define(version: 2024_03_01_154508) do
  create_table "actors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "actors_movies", force: :cascade do |t|
    t.integer "actor_id", null: false
    t.integer "movie_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_actors_movies_on_actor_id"
    t.index ["movie_id"], name: "index_actors_movies_on_movie_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "directors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.integer "countries_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["countries_id"], name: "index_locations_on_countries_id"
  end

  create_table "locations_movies", force: :cascade do |t|
    t.integer "location_id", null: false
    t.integer "movie_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_locations_movies_on_location_id"
    t.index ["movie_id"], name: "index_locations_movies_on_movie_id"
  end

  create_table "movies", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "year"
    t.integer "director_id", null: false
    t.float "avergate_review"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["director_id"], name: "index_movies_on_director_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "movie_id", null: false
    t.integer "user_id", null: false
    t.integer "stars"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_reviews_on_movie_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "actors_movies", "actors"
  add_foreign_key "actors_movies", "movies"
  add_foreign_key "locations", "countries", column: "countries_id"
  add_foreign_key "locations_movies", "locations"
  add_foreign_key "locations_movies", "movies"
  add_foreign_key "movies", "directors"
  add_foreign_key "reviews", "movies"
  add_foreign_key "reviews", "users"
end
