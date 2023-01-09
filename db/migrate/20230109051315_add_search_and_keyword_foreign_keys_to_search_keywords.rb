class AddSearchAndKeywordForeignKeysToSearchKeywords < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :search_keywords, :searches
    add_foreign_key :search_keywords, :keywords
  end
end

