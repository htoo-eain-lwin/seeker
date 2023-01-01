# frozen_string_literal: true

require 'rails_helper'

describe KeywordToResultsService do
  let(:keyword_name) { Fabricate.create(:keyword).name }
  let(:url) { 'http://localhost:3000/test.html' }

  describe 'call' do
    subject(:result) { described_class.call(keyword_name, url) }

    it { expect(result[:stats]).to eq('About 1 result') }
    it { expect(result[:total_urls]).to eq(2) }
    it { expect(result[:total_advertisers]).to eq(1) }

    it 'return html body' do
      file = File.open('public/test.html', 'r')
      body = file.read
      expect(result[:html].delete("\n")).to eq(body.delete("\n"))
    end

    # rubocop:disable RSpec/AnyInstance
    it 'ensure browser reset' do
      expect_any_instance_of(Ferrum::Browser).to receive(:reset)
      result
    end

    it 'ensure browser quit' do
      expect_any_instance_of(Ferrum::Browser).to receive(:quit)
      result
    end

    # rubocop:enable RSpec/AnyInstance
  end
end
