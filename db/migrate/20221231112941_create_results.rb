class CreateResults < ActiveRecord::Migration[7.0]
  def change
    create_table :results do |t|
      t.belongs_to :keyword
      t.string :stats
      t.integer :total_urls
      t.integer :total_advertisers
      t.timestamps
    end
  end
end
