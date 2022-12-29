# frozen_string_literal: true

require 'rails_helper'

describe HomeController, type: :routing do
  it 'route to #index' do
    expect(get('/search/new')).to route_to('search#new')
  end
end
