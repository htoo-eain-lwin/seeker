# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to validate_attached_of(:csv_file) }
    it { is_expected.to validate_content_type_of(:csv_file).allowing('csv') }
  end
end
