class CreateSearchKeyword < ActiveRecord::Migration[7.0]
  def change
    create_table :search_keywords do |t|
      t.belongs_to :search, index: true
      t.belongs_to :keyword, index: true
      t.timestamps
    end
  end
end
