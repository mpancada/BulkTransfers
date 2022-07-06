class AddApiTokenToBankAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :bank_accounts, :api_token, :string, limit: 36
    add_index :bank_accounts, :api_token
  end
end
