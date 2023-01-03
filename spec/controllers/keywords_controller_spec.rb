# frozen_string_literal: true

require 'rails_helper'

describe KeywordsController, type: :controller do
  describe 'GET RESULT' do
    before(:each) do
      login_user
      get :result, params: { id: Fabricate.create(:keyword).id }
    end

    it { expect(response).to have_http_status(:success) }
    it { expect(assigns(:result)).to eq(Result.last) }
  end
end
