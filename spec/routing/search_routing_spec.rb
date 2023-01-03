# frozen_string_literal: true

require 'rails_helper'

describe SearchController, type: :routing do
  it { expect(get('/search/new')).to route_to('search#new') }
  it { expect(get('/search/1')).to route_to('search#show', id: '1') }
  it { expect(post('/search/upload')).to route_to('search#upload') }
end
