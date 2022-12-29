# frozen_string_literal: true

class Search < ApplicationRecord
  belongs_to :user
  belongs_to :keyword
end
