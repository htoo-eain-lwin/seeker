# frozen_string_literal: true

class SearchCrawler
  class YouAreABot < StandardError; end
  USER_AGENTS = [
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) '\
    'Chrome/104.0.5112.79 Safari/537.36',
    'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 '\
    '(KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36',
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.53 Safari/537.36'
  ].freeze
  HEADERS = {
    'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
    'Accept-Language' => 'en-US,en;q=0.9',
    'Content-Type' => 'text/plain',
    'Referer' => 'https://www.google.com'
  }.freeze
  attr_accessor :keywords, :url

  def initialize(keywords_ids, url)
    @keywords = Keyword.where(id: keywords_ids)
    @url = url
    @results = []
    @browser = set_browser
  end

  def set_browser
    Ferrum::Browser.new(headless: true,
                        browser_options: { 'disable-blink-features': 'AutomationControlled' },
                        timeout: 100)
  end

  def user_agent_headers
    { 'USER_AGENT' => USER_AGENTS.sample }
  end

  def results
    return if @keywords.empty?

    init_search
    crawl_results
    @results
  ensure
    exit_browser
  end

  private

  def crawl_results
    @keywords.each_with_index do |keyword, index|
      raise YouAreABot, 'Detected By Google' if check_captcha_exists?

      submit_search(keyword.name) unless index.zero?
      act_like_human
      @results << result_params(keyword.id)
    rescue YouAreABot
      break
    end
  end

  def act_like_human
    @browser.mouse
            .scroll_to(rand(0..500), rand(500..1000))
            .scroll_to(rand(500..1000), rand(1000..2000))
            .scroll_to(rand(500..1000), rand(2000..3500))
  end

  def submit_search(keyword)
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

  def init_search
    @browser.headers.set(HEADERS)
    @browser.headers.add(user_agent_headers)
    @browser.go_to(encode_url)
  end

  def encode_url
    URI.parse("#{@url}?q=#{@keywords[0].name}&hl=en").to_s
  end

  def exit_browser
    @browser&.reset
    @browser&.quit
  end
end
