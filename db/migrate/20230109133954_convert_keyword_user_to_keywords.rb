class ConvertKeywordUserToKeywords < ActiveRecord::Migration[7.0]
  def up
    #Remove name index from keywords table
    remove_index :keywords, :name
    #Add user_id in keywords table
    add_reference :keywords, :user, foreign_key: true
    #Add user_ids from keywords_user table to keywords table
    execute "INSERT INTO keywords(name, user_id, created_at, updated_at) " \
      "select keywords.name, keyword_users.user_id, NOW(), NOW() " \
      "From keyword_users " \
      "JOIN keywords ON keyword_users.keyword_id = keywords.id"
    #Update SearchKeyword table due to new keywords are inserted
    Search.all.each do |search|
      search.keywords.each do |keyword|
        s_keyword = SearchKeyword.find_by(search_id: search.id, keyword_id: keyword.id)
        act_key = Keyword.find_by(name: keyword.name, user_id: search.user_id)
        keyword.result.update(keyword_id: act_key.id) if keyword.result
        s_keyword.update(keyword_id: act_key.id) if act_key
      end
    end
    # drop table keyword_users
    drop_table :keyword_users
    # remove old keywords which has user id nil
    Keyword.where(user_id: nil).destroy_all
  end

  def down
    #You need to create KeywordUser model, with belongs_to :user and belongs_to :keyword
    #create keyword_users table
    create_table :keyword_users do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :keyword, foreign_key: true
      t.timestamps
    end
    #insert values from keywords user_id column to keyword_users table
    execute "INSERT INTO keyword_users(user_id, keyword_id, created_at, updated_at) " \
      "select user_id, id, created_at, updated_at " \
      "From keywords"
    #remove user_id from keywords table
    remove_reference :keywords, :user
    #remove dup keywords, since user_id is remove, keywords can be duplicated,
    dup_records = Keyword.where.not(id: Keyword.select("MIN(id) as id").group(:name))
    dup_records.each do |record|
      k_user = KeywordUser.find_by(keyword_id: record.id)
      id = Keyword.select("MIN(id) as id").where(name: record.name).ids.first
      k_user.update(keyword_id: id)
      result = record.result
      result.update(keyword_id: id) if record.result
    end
    #destroy all dup records
    dup_records.destroy_all
    #can safely added name as index in keywords table
    add_index :keywords, :name
  end
end
