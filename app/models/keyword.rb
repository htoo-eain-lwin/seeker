# frozen_string_literal: true

class Keyword < ApplicationRecord
  validates :name, presence: true

  has_many :keyword_users, dependent: :destroy
  has_many :users, through: :keyword_users
end
