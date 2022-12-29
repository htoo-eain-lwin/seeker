# frozen_string_literal: true

module ControllerMacros
  def login_user
    request.env['devise.mapping'] = Devise.mappings[:user]
    current_user = Fabricate(:user)
    sign_in current_user
    current_user
  end
end
