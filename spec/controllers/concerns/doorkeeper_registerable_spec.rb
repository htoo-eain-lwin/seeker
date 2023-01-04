# frozen_string_literal: true

require 'rails_helper'

class Dummy
  include DoorkeeperRegisterable
end

describe DoorkeeperRegisterable do
  let(:user) { Fabricate.create(:user) }
  let(:application) { Fabricate.create(:application) }

  describe 'render_user' do
    it 'create access token' do
      expect { Dummy.new.render_user(user, application) }.not_to raise_error
    end

    it 'render result' do
      result = Dummy.new.render_user(user, application)
      expect(result[:access_token]).not_to be_nil
    end
  end
end
