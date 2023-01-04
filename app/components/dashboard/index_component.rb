# frozen_string_literal: true

module Dashboard
  class IndexComponent < ApplicationComponent
    def initialize(user:)
      @user = user
      super
    end

    def top_keywords
      @user.keywords
           .group(:name)
           .order(Arel.sql("COUNT('keyword.id') desc"))
           .limit(5)
           .count
    end

    def search_with_most_keywords
      Search.where(user_id: @user.id)
            .joins(:search_keywords)
            .group(:search_id)
            .order(Arel.sql("COUNT('keyword.id') desc"))
            .limit(5).count
    end

    def top_ad_keywords
      @user.keywords
           .distinct
           .joins(:result)
           .order('total_advertisers desc')
           .limit(5)
           .pluck(:name, :total_advertisers)
    end

    def user_latest_searches
      @user.searches.order('id desc').limit(5)
    end

    def user_latest_keywords
      @user.keywords.distinct.limit(5)
    end
  end
end
