class CreateKeywordsUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :keyword_users do |t|
      t.belongs_to :user
      t.belongs_to :keyword
      t.timestamps
    end
  end
end
