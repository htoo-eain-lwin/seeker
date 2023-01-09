# frozen_string_literal: true

class Search < ApplicationRecord
  MAX_SIZE = 1
  has_one_attached :csv_file
  has_many :search_keywords, dependent: :destroy
  has_many :keywords, through: :search_keywords

  belongs_to :user

  validates :csv_file, attached: true, content_type: :csv
end
