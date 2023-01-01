# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Keyword, type: :model do
  describe 'Fabricate' do
    it 'have valid factory' do
      expect { Fabricate.create :keyword }.not_to raise_error
    end
  end

  describe 'validation' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:users).through(:keyword_users) }
    it { is_expected.to have_many(:keyword_users).dependent(:destroy) }
    it { is_expected.to have_one(:result).dependent(:destroy) }
  end
end
