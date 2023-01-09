class AddUserForeignKeyToSearch < ActiveRecord::Migration[7.0]
  def change
     add_foreign_key :searches, :users
  end
end
