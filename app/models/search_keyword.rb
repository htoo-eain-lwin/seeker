# frozen_string_literal: true

class SearchKeyword < ApplicationRecord
  belongs_to :search
  belongs_to :keyword
end
