# frozen_string_literal: true

class BuildSearchService < ApplicationService
  attr_accessor :search

  def initialize(params)
    @search = Search.new(user_id: params[:user_id])
    @params = params
    super
  end

  def call
    return if search.user_id.nil?

    File.write('tmp/temp.csv', @params[:file])
    search.csv_file.attach(io: File.open('tmp/temp.csv', 'r'), filename: file_name)
    search.save
    search
  end

  def file_name
    "#{SecureRandom.uuid}.csv"
  end
end
