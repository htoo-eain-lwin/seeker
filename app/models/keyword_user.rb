# frozen_string_literal: true

class KeywordUser < ApplicationRecord
  belongs_to :user
  belongs_to :keyword
end
