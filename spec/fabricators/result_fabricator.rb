# frozen_string_literal: true

Fabricator(:result) do
  keyword
  stats { "About #{rand(100_000..500_000)} results (#{rand(0.1..3).round(2)} seconds)" }
  total_urls { rand(100_000..500_000) }
  total_advertisers { rand(0..7) }
  html_file do
    Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.html')))
  end
end
