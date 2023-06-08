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
    it { is_expected.to have_many(:keywords).dependent(:destroy) }
    it { is_expected.to have_many(:searches) }
  end

  describe 'authenticate' do
    let(:user) { described_class.create(email: FFaker::Internet.email, password: 'FooBar') }

    context 'when user exists' do
      it { expect(described_class.authenticate(user.email, 'FooBar')).to eq(user) }
    end

    context 'when user does not exists' do
      it { expect(described_class.authenticate(FFaker::Internet.email, FFaker::Internet.password)).to be_nil }
    end
  end
end
