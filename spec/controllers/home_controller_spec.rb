# frozen_string_literal: true

require 'rails_helper'

describe HomeController, type: :controller do
  describe 'Get Index' do
    context 'when user is not logged in' do
      before(:each) { get :index }

      it { expect(response).to have_http_status(:redirect) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'when user is logged in' do
      it 'redirect to dashboard index' do
        login_user
        get :index
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end
end
