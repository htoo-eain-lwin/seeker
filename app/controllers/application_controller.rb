# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Localization
  def after_sign_in_path_for(_resource)
    dashboard_index_path
  end
end
