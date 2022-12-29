# frozen_string_literal: true

require 'rails_helper'

describe HomeController, type: :controller do
  describe 'Get Index' do
    before(:each) { get :index }

    it { expect(response).to have_http_status(:success) }
    it { is_expected.to render_template('index') }
  end
end
