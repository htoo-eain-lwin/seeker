# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe CreateResultsJob, type: :job do
  subject(:job) { described_class.perform_async([]) }

  it 'queues the job' do
    expect { job }
      .to change(described_class.jobs, :size).by(1)
  end

  it 'is in default queue' do
    job
    expect(described_class.jobs.first['queue']).to eq('default')
  end

  describe 'perform' do
    let(:url) { URI.join('file:///', Rails.public_path.join('test.html').to_s) }

    it 'executes perform' do
      crawler = instance_double(SearchCrawler)
      allow(SearchCrawler).to receive(:new).and_return(crawler)
      allow(crawler).to receive(:results).and_return([])

      described_class.new.perform([], url: url)
    end
  end
end
