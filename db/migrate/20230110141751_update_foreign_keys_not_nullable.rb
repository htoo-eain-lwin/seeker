class UpdateForeignKeysNotNullable < ActiveRecord::Migration[7.0]
  def change
     change_column_null :searches, :user_id, false
     change_column_null :search_keywords, :search_id, false
     change_column_null :search_keywords, :keyword_id, false
     change_column_null :results, :keyword_id, false
     change_column_null :keywords, :user_id, false
  end
end
