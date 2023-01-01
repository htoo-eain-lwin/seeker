# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Result, type: :model do
  describe 'Fabricate' do
    it 'have valid factory' do
      expect { Fabricate.create :result }.not_to raise_error
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:keyword) }
    it { is_expected.to validate_attached_of(:html_file) }
    it { is_expected.to validate_content_type_of(:html_file).allowing('html') }
  end
end
