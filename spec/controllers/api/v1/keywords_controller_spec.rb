# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::KeywordsController, type: :controller do
  describe 'Get Index' do
    context 'when user is not logged in' do
      before(:each) { get :index }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'when user is logged in' do
      let(:application) { Fabricate.create(:application) }
      let(:user) { Fabricate.create(:user) }
      let(:keyword) { Fabricate.create(:keyword) }
      let(:token) do
        Fabricate.create(:access_token,
                         application: application,
                         resource_owner_id: user.id)
      end

      before(:each) do
        request.headers[:Authorization] = "Bearer #{token.token}"
        user.keywords << keyword
        get :index, params: { format: :json }
      end

      it { expect(response).to have_http_status(:success) }
      it { expect(assigns(:keywords).count).to eq(user.keywords.count) }
    end
  end
end
