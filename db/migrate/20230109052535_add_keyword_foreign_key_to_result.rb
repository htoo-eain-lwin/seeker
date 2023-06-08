class AddKeywordForeignKeyToResult < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :results, :keywords
  end
end
