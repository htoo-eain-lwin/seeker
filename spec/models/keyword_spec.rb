# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Keyword, type: :model do
  describe 'Fabricate' do
    it 'have valid factory' do
      expect { Fabricate.create :keyword }.not_to raise_error
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:users).through(:searches) }
    it { is_expected.to have_many(:searches) }
  end
end