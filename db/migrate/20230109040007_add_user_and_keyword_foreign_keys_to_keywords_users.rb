class AddUserAndKeywordForeignKeysToKeywordsUsers < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :keyword_users, :users
    add_foreign_key :keyword_users, :keywords
  end
end
