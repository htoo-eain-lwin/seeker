# frozen_string_literal: true

Fabricator(:search) do
  user
  csv_file do
    Rack::Test::UploadedFile.new(
      File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.csv')), 'csv'
    )
  end
end
