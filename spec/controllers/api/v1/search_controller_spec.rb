# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::SearchController, type: :controller do
  describe 'Get Show' do
    context 'when user is not logged in' do
      let(:search) { Fabricate.create(:search) }

      before(:each) { get :show, params: { id: search.id, format: :json } }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'when user is logged in' do
      let(:application) { Fabricate.create(:application) }
      let(:user) { Fabricate.create(:user) }
      let(:search) { Fabricate.create(:search, user: user) }
      let(:token) do
        Fabricate.create(:access_token,
                         application: application,
                         resource_owner_id: user.id)
      end

      before(:each) do
        request.headers[:Authorization] = "Bearer #{token.token}"
        get :show, params: { id: search.id, format: :json }
      end

      it { expect(response).to have_http_status(:success) }
      it { expect(assigns(:search).user).to eq(user) }
    end
  end

  describe 'POST Upload' do
    context 'when user is not logged in' do
      before(:each) { post :upload, params: { search: {}, format: :json } }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'when user is logged in' do
      let(:application) { Fabricate.create(:application) }
      let(:user) { Fabricate.create(:user) }
      let(:search) { Fabricate.create(:search, user: user) }
      let(:token) do
        Fabricate.create(:access_token,
                         application: application,
                         resource_owner_id: user.id)
      end

      before(:each) { request.headers[:Authorization] = "Bearer #{token.token}" }

      # rubocop:disable RSpec/NestedGroups
      context 'when valid params' do
        before(:each) do
          csv = File.read(Rails.root.join('spec', 'fixtures', 'files', 'test.csv'))
          search_params = {
            file: csv,
            content_type: 'csv'
          }
          allow(ImportKeywordsJob).to receive(:perform_async).and_return(true)
          post :upload, params: {
            format: :json,
            search: search_params
          }
        end

        it { expect(response).to have_http_status(:created) }
      end

      context 'when invalid params' do
        before(:each) do
          request.headers[:Authorization] = "Bearer #{token.token}"
          search_params = {
            file: nil,
            content_type: 'txt'
          }
          post :upload, params: {
            format: :json,
            search: search_params
          }
        end

        # rubocop:enable RSpec/NestedGroups
        it { expect(response).to have_http_status(:unprocessable_entity) }
      end
    end
  end
end
