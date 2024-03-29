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

ActiveRecord::Schema[7.0].define(version: 2024_02_14_051600) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "menu_id", null: false
    t.integer "item_count", null: false
    t.datetime "added_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["menu_id"], name: "index_cart_items_on_menu_id"
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "category_name", default: "", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "cooking_flows", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cooking_flows_on_cart_id"
  end

  create_table "cooking_steps", force: :cascade do |t|
    t.bigint "cooking_flow_id", null: false
    t.bigint "recipe_step_id", null: false
    t.bigint "recipe_step_category_id"
    t.string "menu_name", default: "", null: false
    t.integer "step_order"
    t.boolean "is_checked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cooking_flow_id"], name: "index_cooking_steps_on_cooking_flow_id"
    t.index ["recipe_step_category_id"], name: "index_cooking_steps_on_recipe_step_category_id"
    t.index ["recipe_step_id"], name: "index_cooking_steps_on_recipe_step_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "material_name", null: false
    t.bigint "material_id", null: false
    t.bigint "unit_id", null: false
    t.decimal "quantity", precision: 4, scale: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["material_id"], name: "index_ingredients_on_material_id"
    t.index ["unit_id"], name: "index_ingredients_on_unit_id"
  end

  create_table "material_units", force: :cascade do |t|
    t.bigint "material_id", null: false
    t.bigint "unit_id", null: false
    t.integer "conversion_factor", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["material_id"], name: "index_material_units_on_material_id"
    t.index ["unit_id"], name: "index_material_units_on_unit_id"
  end

  create_table "materials", force: :cascade do |t|
    t.string "material_name", null: false
    t.bigint "category_id", null: false
    t.integer "default_unit_id", null: false
    t.string "hiragana", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["category_id"], name: "index_materials_on_category_id"
  end

  create_table "menu_ingredients", force: :cascade do |t|
    t.bigint "menu_id", null: false
    t.bigint "ingredient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_menu_ingredients_on_ingredient_id"
    t.index ["menu_id"], name: "index_menu_ingredients_on_menu_id"
  end

  create_table "menus", force: :cascade do |t|
    t.string "menu_name", default: "", null: false
    t.text "menu_contents"
    t.text "image_meta_data", default: "", null: false
    t.string "image", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipe_step_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipe_steps", force: :cascade do |t|
    t.bigint "menu_id", null: false
    t.bigint "recipe_step_category_id", null: false
    t.integer "step_order"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_recipe_steps_on_menu_id"
    t.index ["recipe_step_category_id"], name: "index_recipe_steps_on_recipe_step_category_id"
  end

  create_table "shopping_list_items", force: :cascade do |t|
    t.bigint "shopping_list_id", null: false
    t.bigint "material_id", null: false
    t.decimal "quantity"
    t.bigint "unit_id", null: false
    t.bigint "category_id", null: false
    t.boolean "is_checked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_shopping_list_items_on_category_id"
    t.index ["material_id"], name: "index_shopping_list_items_on_material_id"
    t.index ["shopping_list_id"], name: "index_shopping_list_items_on_shopping_list_id"
    t.index ["unit_id"], name: "index_shopping_list_items_on_unit_id"
  end

  create_table "shopping_list_menus", force: :cascade do |t|
    t.bigint "shopping_list_id", null: false
    t.bigint "menu_id", null: false
    t.integer "menu_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_shopping_list_menus_on_menu_id"
    t.index ["shopping_list_id"], name: "index_shopping_list_menus_on_shopping_list_id"
  end

  create_table "shopping_lists", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_shopping_lists_on_cart_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "unit_name", default: "", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "user_menus", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "menu_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_user_menus_on_menu_id"
    t.index ["user_id"], name: "index_user_menus_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "menus"
  add_foreign_key "carts", "users"
  add_foreign_key "cooking_flows", "carts"
  add_foreign_key "cooking_steps", "cooking_flows"
  add_foreign_key "cooking_steps", "recipe_step_categories"
  add_foreign_key "cooking_steps", "recipe_steps"
  add_foreign_key "recipe_steps", "menus"
  add_foreign_key "recipe_steps", "recipe_step_categories"
  add_foreign_key "shopping_list_items", "categories"
  add_foreign_key "shopping_list_items", "materials"
  add_foreign_key "shopping_list_items", "shopping_lists"
  add_foreign_key "shopping_list_items", "units"
  add_foreign_key "shopping_list_menus", "menus"
  add_foreign_key "shopping_list_menus", "shopping_lists"
  add_foreign_key "shopping_lists", "carts"
end
