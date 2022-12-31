# frozen_string_literal: true

require 'rails_helper'

describe KeywordsController, type: :controller do
  describe 'POST CREATE' do
    before(:each) { login_user }

    context 'when inalid params' do
      it 'create keyword' do
        post :create, params: { keyword: { name: '' } }
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'when valid params' do
      it 'redirect to dashboard index' do
        post :create, params: { keyword: { name: FFaker.name } }
        expect(response).to redirect_to(result_keyword_path(Keyword.last.name))
      end
    end
  end

  describe 'GET RESULT' do
    before(:each) { login_user }

    it 'show result page' do
      result = instance_double(Result)
      allow(CreateResultService).to receive(:call).and_return(true)
      allow(Result).to receive(:find_by).and_return(result)
      get :result, params: { id: Fabricate.create(:keyword).name }
      expect(response).to have_http_status(:success)
    end
  end
end
