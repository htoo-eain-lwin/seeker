# frozen_string_literal: true

class Result < ApplicationRecord
  belongs_to :keyword
  has_one_attached :html_file
  validates :html_file, attached: true, content_type: :html
end
