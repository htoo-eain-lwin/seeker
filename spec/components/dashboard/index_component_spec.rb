# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dashboard::IndexComponent, type: :component do
  subject(:render) { render_inline(component) }

  let(:user) { Fabricate.create(:user) }
  let(:component) { described_class.new(user: user) }

  describe '#top_keywords' do
    let(:create_data) do
      keyword = Fabricate.create(:keyword, name: 'FOO')
      3.times { user.keywords << keyword }
      other_key = Fabricate.create(:keyword, name: 'Bar')
      user.keywords << other_key
    end

    it 'return key value pair' do
      create_data
      expect(component.top_keywords).to eq({ 'FOO' => 3, 'Bar' => 1 })
    end
  end

  describe '#search_with_most_keywords' do
    let(:create_data) do
      search = Fabricate.create(:search, user: user)
      3.times { search.keywords << Fabricate.create(:keyword) }
      another_search = Fabricate.create(:search, user: user)
      another_search.keywords << Fabricate.create(:keyword)
    end

    it 'return key value pair' do
      create_data
      search_values = component.search_with_most_keywords.values
      expect(search_values[0] > search_values[1]).to be(true)
    end
  end

  describe '#top_ad_keywords' do
    let(:create_data) do
      5.times { user.keywords << Fabricate.create(:keyword) }
      Keyword.all.each { |key| Fabricate.create(:result, keyword: key) }
    end

    it 'return top at keywords with count' do
      create_data
      keywords = component.top_ad_keywords
      expect(keywords[0][1] > keywords[-1][1]).to be(true)
    end
  end

  describe 'user_latest_searches' do
    it 'return searches' do
      Fabricate.create(:search, user: user)
      expect(component.user_latest_searches.present?).to be(true)
    end
  end

  describe 'user_latest_keywords' do
    it 'return keywords' do
      3.times { user.keywords << Fabricate.create(:keyword) }
      expect(component.user_latest_keywords.present?).to be(true)
    end
  end
end
