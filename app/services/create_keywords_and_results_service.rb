# frozen_string_literal: true

class CreateKeywordsAndResultsService < ApplicationService
  class YouAreABot < StandardError; end
  HEDAERS = {
    'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
    'Accept-Language' => 'en-US,en;q=0.9',
    'Content-Type' => 'text/plain',
    'Referer' => 'https://www.google.com',
    'USER_AGENT' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7 '\
                    'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36'
  }.freeze
  URL = 'https://www.google.com/search'

  def initialize(search_id, url: nil)
    @search = Search.find_by id: search_id
    @keywords = @search.keywords_from_file
    @browser = set_browser
    @url = url || URL
    super
  end

  def call
    return if @keywords.empty?

    init_search
    create_keywords_and_results
    act_like_human
  ensure
    exit_browser
  end

  def create_keywords_and_results
    raise YouAreABot, 'Detected By Google' if check_captcha_exists?

    @keywords.each_with_index do |key, index|
      keyword = CreateKeywordService.call(key, @search.id)
      google_search(keyword.name) unless index.zero?
      CreateResultService.call(result_params(keyword.id))
    end
  end

  def set_browser
    Ferrum::Browser.new(headless: true,
                        browser_options: { 'disable-blink-features': 'AutomationControlled' },
                        timeout: 100)
  end

  def exit_browser
    @browser&.reset
    @browser&.quit
  end

  private

  def init_search
    @browser.headers.set(HEDAERS)
    @browser.go_to("#{@url}?q=#{@keywords[0]}&hl=en")
  end

  def act_like_human
    sleep rand(5)
    @browser.mouse
            .scroll_to(rand(0..500), rand(500..1000))
            .scroll_to(rand(500..1000), rand(1000..2000))
            .scroll_to(rand(500..1000), rand(2000..3500))
    sleep rand(5)
  end

  def google_search(keyword)
    clear_btn = @browser.at_xpath("//div[@aria-label='Clear']")
    clear_btn.click
    @browser.keyboard.type(keyword, :Enter)
  rescue Ferrum::NodeNotFoundError
    sleep 0.1
    retry
  end

  def result_params(keyword_id)
    {
      keyword_id: keyword_id,
      stats: stats,
      total_urls: urls,
      total_advertisers: total_advertisers,
      html_file: @browser.body
    }
  rescue Ferrum::NodeNotFoundError
    sleep 0.1
    retry
  end

  def check_captcha_exists?
    @browser.at_xpath("//form[@id='captcha-form']").present?
  end

  def stats
    node = @browser.at_xpath("//div[@id='result-stats']")
    raise Ferrum::NodeNotFoundError, 'node' unless node

    node.text
  end

  def urls
    @browser.css('a').pluck(:href).count
  end

  def total_advertisers
    @browser.xpath("//div[@data-text-ad='1']").count
  end
end
