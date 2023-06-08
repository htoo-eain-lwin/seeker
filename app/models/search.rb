# frozen_string_literal: true

class Search < ApplicationRecord
  has_many :search_keywords, dependent: :destroy
  has_many :keywords, through: :search_keywords

  belongs_to :user
end
