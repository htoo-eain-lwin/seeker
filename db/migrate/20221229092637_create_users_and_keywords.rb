class CreateUsersAndKeywords < ActiveRecord::Migration[7.0]
  def change
    create_table :keywords do |t|
      t.string :name
      t.timestamps
    end

    create_table :users_and_keywords do |t|
      t.belongs_to :user
      t.belongs_to :keyword
      t.timestamps
    end
  end
end
