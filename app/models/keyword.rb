# frozen_string_literal: true

class Keyword < ApplicationRecord
  validates :name, presence: true

  has_many :searches, dependent: :destroy
  has_many :users, through: :searches
end
