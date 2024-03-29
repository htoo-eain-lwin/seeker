# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Keyword, type: :model do
  describe 'Fabricate' do
    it 'have valid factory' do
      expect { Fabricate.create :keyword }.not_to raise_error
    end
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one(:result).dependent(:destroy) }
    it { is_expected.to have_many(:searches).through(:search_keywords) }
    it { is_expected.to have_many(:search_keywords).dependent(:destroy) }
  end
end
