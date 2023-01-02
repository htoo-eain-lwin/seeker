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
    it { is_expected.to validate_attached_of(:csv_file) }
    it { is_expected.to validate_content_type_of(:csv_file).allowing('.csv') }
  end

  describe '#list_keywords' do
    subject(:search) { Fabricate.create :search }

    it { expect(search.list_keywords.class).to eq(Array) }
  end
end
