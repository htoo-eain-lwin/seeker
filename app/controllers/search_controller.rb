# frozen_string_literal: true

class SearchController < ApplicationController
  before_action :authenticate_user!

  def new; end
end
