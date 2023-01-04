# frozen_string_literal: true

class Keyword < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :keyword_users, dependent: :destroy
  has_many :users, through: :keyword_users
  has_many :search_keywords, dependent: :destroy
  has_many :searches, through: :search_keywords

  has_one :result, dependent: :destroy

  after_create_commit -> { broadcast_append_to 'keywords' }
end
