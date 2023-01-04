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

  describe 'Get Show' do
    let(:search) { Fabricate.create(:search) }

    before :each do
      login_user
      get :show, params: { id: search.id }
    end

    it { expect(response).to have_http_status(:success) }
    it { is_expected.to render_template('show') }
    it { expect(assigns(:keywords)).to eq(search.keywords) }
  end

  describe 'POST Upload' do
    let(:file) do
      Rack::Test::UploadedFile.new(
        File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.csv')), 'csv'
      )
    end

    before(:each) do
      login_user
      allow(CreateKeywordsAndResultsService).to receive(:call)
      post :upload, params: { search: { csv_file: file } }
    end

    it { expect(response).to have_http_status(:redirect) }
    it { expect(response).to redirect_to(new_search_result_path(Search.last.id)) }
  end
end
