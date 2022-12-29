# frozen_string_literal: true

require 'rails_helper'

describe DashboardController, type: :routing do
  it 'route to #index' do
    expect(get('/dashboard')).to route_to('dashboard#index')
  end
end
