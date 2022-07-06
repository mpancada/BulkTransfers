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

ActiveRecord::Schema[7.0].define(version: 2022_07_06_212333) do
  create_table "bank_accounts", force: :cascade do |t|
    t.text "organization_name"
    t.integer "balance_cents"
    t.text "iban"
    t.text "bic"
    t.string "api_token", limit: 36
    t.index ["api_token"], name: "index_bank_accounts_on_api_token"
  end

  create_table "transactions", force: :cascade do |t|
    t.text "counterparty_name"
    t.text "counterparty_iban"
    t.text "counterparty_bic"
    t.integer "amount_cents"
    t.text "amount_currency"
    t.integer "bank_account_id"
    t.text "description"
  end

end
