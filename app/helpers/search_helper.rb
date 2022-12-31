# frozen_string_literal: true

module SearchHelper
  def list_keywords(csv_file)
    csv = csv_file.download
    csv.split("\n")
  end
end
