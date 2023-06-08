# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ImportKeywordsJob, type: :job do
  subject(:job) { described_class.perform_async(search.id) }

  let(:search) { Fabricate.create(:search) }

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
      allow(CreateKeywordsAndResultsService).to receive(:call).and_return(true)
      described_class.new.perform(search.id)
    end
  end
end
