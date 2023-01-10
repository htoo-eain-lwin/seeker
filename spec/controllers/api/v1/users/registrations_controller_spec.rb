# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::RegistrationsController, type: :controller do
  describe 'create' do
    let(:application) { Fabricate.create(:application) }

    let(:params) do
      {
        client_id: application.uid,
        email: FFaker::Internet.email,
        password: FFaker::Internet.password
      }
    end

    context 'when empty user params' do
      it 'return 401' do
        post :create, params: {}
        expect(response.status).to eq(401)
      end
    end

    context 'when invalid user params' do
      before(:each) { post :create, params: params.except(:password, :email) }

      it 'return converted error message' do
        expect(JSON.parse(response.body)['errors'].count).to eq(3)
      end

      it { expect(response.status).to eq(422) }
    end

    context 'when user params are valid' do
      let(:body) { JSON.parse(response.body) }

      before(:each) do
        post :create, params: params
      end

      it { expect(response.status).to eq(200) }

      it { expect(body['access_token']).not_to be_nil }
    end
  end
end
