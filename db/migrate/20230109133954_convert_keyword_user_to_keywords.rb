class ConvertKeywordUserToKeywords < ActiveRecord::Migration[7.0]
  def up
    add_reference :keywords, :user, foreign_key: true
    remove_index :keywords, :name
    execute "INSERT INTO keywords(name, user_id, created_at, updated_at) " \
      "select keywords.name, keyword_users.user_id, NOW(), NOW() " \
      "From keyword_users " \
      "JOIN keywords ON keyword_users.keyword_id = keywords.id"
    drop_table :keyword_users
    Keyword.where(user_id: nil).destroy_all
  end

  def down
    create_table :keyword_users do |t|
      t.belongs_to :user
      t.belongs_to :keyword
      t.timestamps
    end
    execute "INSERT INTO keyword_users(user_id, keyword_id, created_at, updated_at) " \
      "select user_id, id, created_at, updated_at " \
      "From keywords"
    add_foreign_key :keyword_users, :users
    add_foreign_key :keyword_users, :keywords
    add_index :keywords, :name
    remove_reference :keywords, :user
  end
end
