# frozen_string_literal: true

class KeywordToResultsService < ApplicationService
  HEDAERS = {
    'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
    'Accept-Encoding' => 'br',
    'Accept-Language' => 'en-US,en;q=0.9',
    'Cache-Control' => 'max-age=0',
    'Connection' => 'keep-alive',
    'Content-Disposition' => 'attachment',
    'USER_AGENT' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7 '\
                    'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36'
  }.freeze

  def initialize(keyword_name, url)
    @keyword_name = keyword_name
    @browser = Ferrum::Browser.new
    @url = url
    super
  end

  def call
    search
    results
  ensure
    quit_browser
  end

  def search
    @browser.headers.set(HEDAERS)
    @browser.go_to(@url)
    input = @browser.at_xpath("//input[@name='q']")
    input&.focus
    input&.type(@keyword_name, :Enter)
  end

  def results
    {
      stats: stats,
      total_urls: total_urls,
      total_advertisers: total_ad_words_advertisers,
      html: html_page
    }
  end

  private

  def total_ad_words_advertisers
    @browser.xpath("//div[@data-text-ad='1']").count
  end

  def total_urls
    @browser.css('a').pluck(:href).count
  end

  def stats
    node = @browser.at_xpath("//div[@id='result-stats']")
    node.text
  rescue Ferrum::NodeNotFoundError, NoMethodError
    sleep 0.1
    retry
  end

  def html_page
    @browser.body
  end

  def quit_browser
    @browser.reset
    @browser.quit
  end
end
