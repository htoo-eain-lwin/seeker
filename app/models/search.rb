# frozen_string_literal: true

class Search < ApplicationRecord
  MAX_SIZE = 1
  has_one_attached :csv_file
  has_many :keywords, dependent: :destroy

  belongs_to :user

  validates :csv_file, attached: true, content_type: :csv

  def keywords_from_file
    ApplicationController.helpers.list_keywords(csv_file)
  end
end
