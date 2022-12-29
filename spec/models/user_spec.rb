# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Fabricate' do
    it 'have valid factory' do
      expect { Fabricate.create :user }.not_to raise_error
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:keyword_users) }
    it { is_expected.to have_many(:keywords).through(:keyword_users) }
    it { is_expected.to have_many(:searches) }
  end
end
