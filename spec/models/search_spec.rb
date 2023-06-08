# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search, type: :model do
  describe 'valid factory' do
    it 'have valid factory' do
      expect { Fabricate.create :search }.not_to raise_error
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:keywords).through(:search_keywords) }
    it { is_expected.to have_many(:search_keywords).dependent(:destroy) }
  end
end
