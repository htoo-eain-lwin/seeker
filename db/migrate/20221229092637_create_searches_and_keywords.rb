class CreateSearchesAndKeywords < ActiveRecord::Migration[7.0]
  def change
    create_table :keywords do |t|
      t.string :name
      t.timestamps
    end

    create_table :searches do |t|
      t.belongs_to :user
      t.timestamps
    end
  end
end
