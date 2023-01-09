# frozen_string_literal: true

class Keyword < ApplicationRecord
  validates :name, presence: true

  belongs_to :user
  has_many :search_keywords, dependent: :destroy
  has_many :searches, through: :search_keywords

  has_one :result, dependent: :destroy
end
