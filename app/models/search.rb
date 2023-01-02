# frozen_string_literal: true

class Search < ApplicationRecord
  MAX_SIZE = 1
  has_one_attached :csv_file
  belongs_to :user

  validates :csv_file, attached: true, content_type: :csv

  def list_keywords
    ApplicationController.helpers.list_keywords(csv_file)
  end
end
