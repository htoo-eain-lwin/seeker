# frozen_string_literal: true

require 'rails_helper'

class Dummy < ApplicationRecord
  self.table_name = 'users'
  validates :email, presence: true
  include JsonApiErrors
end

RSpec.describe JsonApiErrors do
  let(:model) do
    Dummy.new
  end

  describe '.full_messages' do
    let(:desired_format) do
      [
        {
          status: '422',
          source: { pointer: '/data/attributes/email' },
          title: "can't be blank",
          detail: "can't be blank"
        }
      ]
    end

    it 'returns the error messages in the desired format' do
      model.validate
      expect(model.full_messages).to eq desired_format
    end
  end
end
