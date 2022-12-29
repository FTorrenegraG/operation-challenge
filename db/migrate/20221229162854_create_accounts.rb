class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :client_name
      t.string :manager_name

      t.timestamps
    end
  end
end
