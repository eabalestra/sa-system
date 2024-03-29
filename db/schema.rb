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

ActiveRecord::Schema[7.1].define(version: 2024_02_28_184924) do
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

  create_table "balances", force: :cascade do |t|
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "dir"
    t.string "email"
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "cod"
    t.string "name"
    t.string "description"
    t.integer "existence"
    t.date "last_price_update_date"
    t.date "last_stock_update_date"
    t.decimal "unit_cost"
    t.decimal "selling_unit_price"
    t.string "image_product"
    t.integer "supplier_id"
    t.decimal "iva_amount", precision: 8, scale: 2
    t.decimal "profit_margin", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supplier_id"], name: "index_products_on_supplier_id"
  end

  create_table "purchase_details", force: :cascade do |t|
    t.integer "quantity"
    t.integer "product_id", null: false
    t.integer "purchase_id", null: false
    t.decimal "price_at_purchase"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_purchase_details_on_product_id"
    t.index ["purchase_id"], name: "index_purchase_details_on_purchase_id"
  end

  create_table "purchase_payments", force: :cascade do |t|
    t.integer "purchase_id", null: false
    t.decimal "amount"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["purchase_id"], name: "index_purchase_payments_on_purchase_id"
    t.index ["user_id"], name: "index_purchase_payments_on_user_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.decimal "total_amount"
    t.integer "user_id"
    t.integer "supplier_id"
    t.integer "payment_status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supplier_id"], name: "index_purchases_on_supplier_id"
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "sale_details", force: :cascade do |t|
    t.integer "quantity"
    t.integer "product_id", null: false
    t.integer "sale_id", null: false
    t.decimal "price_at_sale"
    t.decimal "discount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_sale_details_on_product_id"
    t.index ["sale_id"], name: "index_sale_details_on_sale_id"
  end

  create_table "sale_payments", force: :cascade do |t|
    t.integer "sale_id", null: false
    t.decimal "amount", null: false
    t.datetime "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["sale_id"], name: "index_sale_payments_on_sale_id"
    t.index ["user_id"], name: "index_sale_payments_on_user_id"
  end

  create_table "sales", force: :cascade do |t|
    t.decimal "total_amount"
    t.integer "user_id"
    t.integer "client_id"
    t.integer "payment_status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_sales_on_client_id"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "dir"
    t.string "email"
    t.string "city"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal "amount"
    t.string "description"
    t.integer "transaction_type"
    t.integer "sale_payments_id"
    t.integer "purchase_payments_id"
    t.integer "user_id", null: false
    t.integer "balance_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["balance_id"], name: "index_transactions_on_balance_id"
    t.index ["purchase_payments_id"], name: "index_transactions_on_purchase_payments_id"
    t.index ["sale_payments_id"], name: "index_transactions_on_sale_payments_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "actual_balance", default: "0.0"
    t.integer "role"
    t.index ["actual_balance"], name: "index_users_on_actual_balance"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "products", "suppliers"
  add_foreign_key "purchase_details", "products"
  add_foreign_key "purchase_details", "purchases"
  add_foreign_key "purchase_payments", "purchases"
  add_foreign_key "purchase_payments", "users"
  add_foreign_key "purchases", "suppliers"
  add_foreign_key "purchases", "users"
  add_foreign_key "sale_details", "products"
  add_foreign_key "sale_details", "sales"
  add_foreign_key "sale_payments", "sales"
  add_foreign_key "sale_payments", "users"
  add_foreign_key "sales", "clients"
  add_foreign_key "sales", "users"
  add_foreign_key "transactions", "balances"
  add_foreign_key "transactions", "purchase_payments", column: "purchase_payments_id"
  add_foreign_key "transactions", "sale_payments", column: "sale_payments_id"
  add_foreign_key "transactions", "users"
end
