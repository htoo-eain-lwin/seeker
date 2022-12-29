# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeHelper, type: :helper do
  describe '#resource_name' do
    it 'return user as a symbol' do
      expect(resource_name).to eq(:user)
    end
  end

  describe '#resource_class' do
    it 'return user class' do
      expect(resource_class).to eq(User)
    end
  end

  describe '#resource' do
    it 'return user object' do
      user = User.new
      allow(User).to receive(:new).and_return(user)
      expect(resource).to eq(user)
    end
  end

  describe '#devise_mapping' do
    it 'return devise mapping' do
      expect(devise_mapping).to eq(Devise.mappings[:user])
    end
  end
end
