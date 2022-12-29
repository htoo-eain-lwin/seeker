# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeHelper, type: :helper do
  describe '#resource' do
    it 'return user object' do
      user = User.new
      allow(User).to receive(:new).and_return(user)
      expect(resource).to eq(user)
    end
  end

  it { expect(resource_name).to eq(:user) }
  it { expect(resource_class).to eq(User) }
  it { expect(devise_mapping).to eq(Devise.mappings[:user]) }
end
