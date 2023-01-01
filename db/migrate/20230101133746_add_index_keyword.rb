class AddIndexKeyword < ActiveRecord::Migration[7.0]
  def change
    add_index :keywords, :name
  end
end
