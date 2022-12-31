# frozen_string_literal: true

require 'rails_helper'

describe SearchController, type: :controller do
  describe 'Get New' do
    context 'when user is not logged in' do
      before(:each) { get :new }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'when user is logged in' do
      before :each do
        login_user
        get :new
      end

      it { expect(response).to have_http_status(:success) }
      it { is_expected.to render_template('new') }
      it { expect(assigns(:search)).to be_a_new(Search) }
    end
  end
end
