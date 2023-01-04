class AddActiveToUserAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :user_accounts, :active, :boolean, default: true
  end
end
