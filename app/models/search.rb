# frozen_string_literal: true

class Search < ApplicationRecord
  MAX_SIZE = 1
  has_one_attached :csv_file

  belongs_to :user
end
