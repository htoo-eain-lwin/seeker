# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateResultService do
  subject(:result_service) { described_class.call(params) }

  let(:keyword) { Fabricate.create :keyword }
  let(:params) do
    {
      keyword_id: keyword.id,
      stats: "About #{rand(100_000..500_000)} results (#{rand(0.1..3).round(2)} seconds)",
      total_urls: rand(100_000..500_000),
      total_advertisers: rand(0..7),
      html_file: Rack::Test::UploadedFile.new(
        File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.html'))
      )
    }
  end

  describe 'call' do
    it { expect { result_service }.not_to raise_error }

    it 'save result' do
      expect { result_service }.to change(Result, :count).by(1)
    end
  end

  describe 'file' do
    it 'return io to attach' do
      expect(described_class.new('foo').file('bar').class).to eq(StringIO)
    end
  end

  describe 'file_name' do
    it { expect(described_class.new('foo').file_name.class).to eq(String) }
  end
end
