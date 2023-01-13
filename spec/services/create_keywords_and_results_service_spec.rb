# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateKeywordsAndResultsService do
  include ActiveStorage::Blob::Analyzable

  let(:search) { Fabricate.create :search }

  describe 'call' do
    it { expect(described_class.new(search.id, []).call).to be_nil }

    it 'create keywords' do
      allow(CreateResultsJob).to receive(:perform_async).and_return(true)
      described_class.new(search.id, %w[foo bar]).call
      expect(Keyword.count).to eq(2)
    end
  end
end
