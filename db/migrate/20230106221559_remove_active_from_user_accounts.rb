class RemoveActiveFromUserAccounts < ActiveRecord::Migration[6.1]
  def change
    remove_column :user_accounts, :active, :boolean
  end
end
