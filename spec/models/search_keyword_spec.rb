# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchKeyword, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:search) }
    it { is_expected.to belong_to(:keyword) }
  end
end
