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

ActiveRecord::Schema[7.0].define(version: 2021_10_28_104629) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorization_identities", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.string "group_id", limit: 36, null: false
  end

  create_table "authorization_permissions", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.string "owner_id", limit: 36, null: false
    t.string "policy_id", limit: 36, null: false
    t.string "owner_type", null: false
    t.json "conditions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "policy_id"], name: "unique_permissions_owner_id_policy_id", unique: true
  end

  create_table "authorization_policies", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "resource_type", null: false
    t.string "action", null: false
    t.integer "effect", limit: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "unique_policies_name", unique: true
    t.index ["resource_type", "action", "effect"], name: "unique_resource_type_action_effect", unique: true
  end

  create_table "authorization_role_grants", id: false, force: :cascade do |t|
    t.string "id", limit: 36, null: false
    t.string "identity_id", limit: 36, null: false
    t.string "role_id", limit: 36, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "unique_role_grants_identity_id", unique: true
  end

  create_table "authorization_roles", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "unique_roles_name", unique: true
  end

  create_table "authorization_user_groups", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "unique_user_groups_name", unique: true
  end

  add_foreign_key "authorization_identities", "authorization_user_groups", column: "group_id"
  add_foreign_key "authorization_permissions", "authorization_policies", column: "policy_id"
  add_foreign_key "authorization_role_grants", "authorization_identities", column: "identity_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "authorization_role_grants", "authorization_roles", column: "role_id", on_update: :cascade, on_delete: :cascade
end
