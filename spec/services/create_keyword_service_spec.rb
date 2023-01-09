# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateKeywordService do
  include ActiveStorage::Blob::Analyzable
  subject(:keyword_service) { described_class.call('foo', search.id) }

  let(:user) { Fabricate.create :user }
  let(:search) { Fabricate.create :search, user: user }
  let(:keyword) { Fabricate.create :keyword, search: search }

  describe 'call' do
    it { expect { keyword_service }.not_to raise_error }

    context 'when existing keyword' do
      it { expect(described_class.call(keyword.name, search.id)).to eq(keyword) }
    end

    context 'when new keyword' do
      it { expect(keyword_service.name).to eq('foo') }

      it 'save in users' do
        expect(keyword_service.users.include?(user)).to be(true)
      end

      it 'save in search' do
        expect(keyword_service.search).to eq(search)
      end
    end

    context 'when search id nil' do
      it { expect(described_class.call('foo', nil)).to be_nil }
    end
  end
end
