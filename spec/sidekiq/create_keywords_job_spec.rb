# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe CreateKeywordsJob, type: :job do
  subject(:job) do
    search = Search.last
    described_class.perform_async(search.id)
  end

  before(:each) { Fabricate.create(:search) }

  it 'queues the job' do
    expect { job }
      .to change(described_class.jobs, :size).by(1)
  end

  it 'is in default queue' do
    job
    expect(described_class.jobs.first['queue']).to eq('default')
  end

  describe 'perform' do
    it 'executes perform' do
      search = Search.last
      keywords = ApplicationController.helpers.list_keywords(search.csv_file)
      described_class.new.perform(search.id)
      expect(Keyword.all.count).to eq(keywords.count)
    end

    it 'does nothing if search not found' do
      expect(described_class.new.perform(rand(100))).to be_nil
    end
  end
end
