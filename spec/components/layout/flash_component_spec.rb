# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Layout::FlashComponent, type: :component do
  subject(:render) { render_inline(component) }

  let(:flash) do
    {
      notice: 'Notice',
      error: 'Error'
    }.with_indifferent_access
  end

  let(:component) { described_class.new(flash) }

  it 'renders footer' do
    expect(render.css('.alert').count).to eq(2)
  end
end
