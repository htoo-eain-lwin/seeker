class AddSearchIdToKeywords < ActiveRecord::Migration[7.0]

  def up
    add_reference :keywords, :search, foreign_key: true
    remove_index :keywords, :name
    remove_foreign_key :search_keywords, :searches
    remove_foreign_key :search_keywords, :keywords

    execute "INSERT INTO keywords(name, search_id, created_at, updated_at) " \
      "select keywords.name, search_keywords.search_id, NOW(), NOW() " \
      "From search_keywords " \
      "JOIN keywords ON search_keywords.keyword_id = keywords.id"
    Keyword.where(search_id: nil).destroy_all
    remove_foreign_key :search_keywords, :searches
    remove_foreign_key :search_keywords, :keywords
    drop_table :search_keywords
  end

  def down
    # create_table :search_keywords do |t|
    #   t.belongs_to :search, index: true
    #   t.belongs_to :keyword, index: true
    #   t.timestamps
    # end
    execute "INSERT INTO search_keywords(search_id, keyword_id, created_at, updated_at) " \
      "select id, search_id, created_at, updated_at " \
      "From keywords"
    add_foreign_key :search_keywords, :searches
    add_foreign_key :search_keywords, :keywords
    add_index :keywords, :name
    remove_reference :keywords, :search
  end
end



