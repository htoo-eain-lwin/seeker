# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    # Here we're using FactoryBot, but you could use anything
    subject { Fabricate.build(:user) }

    it { should validate_presence_of(:email) }
  end
end
