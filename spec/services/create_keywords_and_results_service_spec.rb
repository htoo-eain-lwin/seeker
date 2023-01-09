# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateKeywordsAndResultsService do
  include ActiveStorage::Blob::Analyzable

  subject(:service) { described_class.new(search.id).call }

  let(:search) { Fabricate.create :search }

  describe 'call' do
    it 'return if keywords are empty' do
      allow(Search).to receive(:find_by).and_return(search)
      allow(CsvService).to receive(:call).and_return([])
      expect(service).to be_nil
    end

    it 'create keywords' do
      allow(CreateResultsJob).to receive(:perform_async).and_return(true)
      service
      expect(Keyword.count).to eq(CsvService.call(search).count)
    end
  end
end
