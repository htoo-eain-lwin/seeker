# frozen_string_literal: true

require 'rails_helper'

describe HomeController, type: :routing do
  it 'route to #index' do
    expect(get('/')).to route_to('home#index')
  end
end
