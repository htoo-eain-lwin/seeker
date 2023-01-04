# frozen_string_literal: true

require 'rails_helper'

describe ResultsController, type: :controller do
  describe 'Get New' do
    context 'when user is logged in' do
      before :each do
        login_user
        search = Fabricate.create(:search)
        get :new, params: { search_id: search.id }
      end

      it { expect(response).to have_http_status(:success) }
      it { is_expected.to render_template('new') }
      it { expect(assigns(:search).class).to be(Search) }
      it { expect(assigns(:keywords)).to eq([]) }
    end
  end

  describe 'Get Index' do
    context 'when user is logged in' do
      before :each do
        user = login_user
        10.times.each do
          keyword = Fabricate.create(:keyword)
          user.keywords << keyword
          Fabricate.create(:result, keyword: keyword)
        end

        get :index
      end

      it { expect(response).to have_http_status(:success) }
      it { is_expected.to render_template('index') }
      it { expect(assigns(:keywords).count).to eq(10) }
      it { expect(assigns(:q).result.count).to eq(10) }
    end
  end

  describe 'POST Import' do
    let(:search) { Fabricate.create(:search) }

    before(:each) do
      login_user
      allow(CreateKeywordsAndResultsService).to receive(:call)
      post :import, params: { search_id: search.id }
    end

    it { expect(response).to have_http_status(:ok) }

    it { expect(response).to render_template(layout: false) }

    it 'return turbo stream' do
      turbo_stream = "<turbo-stream action=replace target=search_#{search.id}>"
      expect(response.body.delete('"')).to include(turbo_stream)
    end
  end
end
