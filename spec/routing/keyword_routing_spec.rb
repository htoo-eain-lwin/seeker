# frozen_string_literal: true

require 'rails_helper'

describe KeywordsController, type: :routing do
  it { expect(get('/keywords')).to route_to('keywords#index') }
  it { expect(get('/keywords/foo')).to route_to('keywords#show', id: 'foo') }
  it { expect(get('/keywords/foo/result')).to route_to('keywords#result', id: 'foo') }
end
