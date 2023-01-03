# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateKeywordsAndResultsService do
  include ActiveStorage::Blob::Analyzable

  subject(:service) { described_class.new(search.id) }

  let(:search) { Fabricate.create :search }
  let(:keyword) { Fabricate.create :keyword }
  let(:url) { 'http://localhost:3000/test.html' }
  let(:result) { Fabricate.create :result }

  describe 'call' do
    it 'return if keywords are empty' do
      allow(Search).to receive(:find_by).and_return(search)
      allow(search).to receive(:keywords_from_file).and_return([])
      expect(described_class.call(search.id)).to be_nil
    end

    # rubocop:disable Layout/AnyInstance, RSpec/MultipleExpectations, RSpec/MessageSpies, Rspec/ExampleLength
    it 'create keyword and result' do
      allow_any_instance_of(described_class).to receive(:google_search).and_return(true)
      allow_any_instance_of(described_class).to receive(:act_like_human).and_return(true)
      expect(CreateKeywordService)
        .to receive(:call)
        .and_return(keyword)
        .exactly(search.keywords_from_file.count).times
      expect(CreateResultService)
        .to receive(:call)
        .and_return(true)
        .exactly(search.keywords_from_file.count).times
      described_class.call(search.id, url: url)
    end
    # rubocop:enable Layout/AnyInstance, RSpec/MultipleExpectations, RSpec/MessageSpies,  Rspec/ExampleLength
  end

  describe 'set_browser' do
    it { expect { service.set_browser }.not_to raise_error }
  end

  describe 'exit_browser' do
    it { expect { service.exit_browser }.not_to raise_error }
  end
end
