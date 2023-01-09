# frozen_string_literal: true

class Keyword < ApplicationRecord
  validates :name, presence: true

  has_many :keyword_users, dependent: :destroy
  has_many :users, through: :keyword_users

  belongs_to :search

  # belongs_to :search

  has_one :result, dependent: :destroy

  after_create_commit -> { broadcast_append_to 'keywords' }
end
