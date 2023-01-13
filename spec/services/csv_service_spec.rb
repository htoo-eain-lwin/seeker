# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvService do
  include ActiveStorage::Blob::Analyzable
  subject(:csv_service) { described_class.call(content) }

  let(:content) { "#{FFaker::Name.name}\n#{FFaker::Name.name},#{FFaker::Name.name}" }

  describe 'call' do
    it { expect { csv_service }.not_to raise_error }

    it { expect(csv_service.count).to eq(3) }

    it { expect(csv_service.class).to eq(Array) }
  end
end
