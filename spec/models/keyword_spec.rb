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

  # rubocop:disable RSpec/StubbedMock, RSpec/MessageSpies
  describe 'callback' do
    it 'call turbo after create' do
      expect(Turbo::StreamsChannel).to receive(:broadcast_append_to).and_return(true)
      Fabricate.create :keyword
    end
  end
  # rubocop:enable RSpec/StubbedMock, RSpec/MessageSpies

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one(:result).dependent(:destroy) }
    it { is_expected.to have_many(:searches).through(:search_keywords) }
    it { is_expected.to have_many(:search_keywords).dependent(:destroy) }
  end
end
