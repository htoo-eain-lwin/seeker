# frozen_string_literal: true

class Keyword < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :keyword_users, dependent: :destroy
  has_many :users, through: :keyword_users

  has_one :result, dependent: :destroy
end
