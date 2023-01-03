require 'rails_helper'

RSpec.describe "Results", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/results/index"
      expect(response).to have_http_status(:success)
    end
  end

end
