require 'httparty'
require 'ostruct'
module DynectEmail
  class Error < StandardError; end

  include HTTParty
  base_uri 'http://emailapi.dynect.net/rest/json'
  class << self
    attr_accessor :api_key
  end

  # senders

  def self.add_sender(email, apikey=nil)
    request(:post, "/senders", {:emailaddress => email}, apikey)
  end

  def self.remove_sender(email, apikey=nil)
    request(:post, "/senders/delete", {:emailaddress => email}, apikey)
  end

  # accounts

  def self.add_account(username, password, company, phone, options={})
    request(:post, "/accounts", options.merge({:username => username, :password => password, :companyname => company, :phone => phone}))
  end

  def self.remove_account(username)
    request(:post, "/accounts/delete", :username => username)
  end

  # reports/bounces

  def self.get_bounces_count(options = {})
    request(:get, "/reports/bounces/count", options)
  end

  def self.get_bounces(options = {})
    request(:get, "/reports/bounces", options)
  end

  # suppressions

  def self.get_suppressions_count(options = {})
    request(:get, "/suppressions/count", options)
  end

  def self.get_suppressions(options = {})
    request(:get, "/suppressions", options)
  end

  def self.activate_suppression(email)
    request(:post, "/suppressions/activate", :emailaddress => email)
  end

  # {:xheader1 => "X-header", xheader2 => ....}
  def self.set_headers(headers, apikey=nil)
    request(:post, "/accounts/xheaders", headers, apikey)
  end

  private
  def self.handle_response(response)
    message = response['response']['message']
    raise DynectEmail::Error, message unless message == 'OK'
    response['response']['data']
  end

  def self.request(http_method, url, options={}, apikey=nil)
    options.merge!(:apikey => apikey || DynectEmail.api_key)
    result = case http_method
    when :post
      post(url, :body => options)
    when :get
      get(url, :query => options)
    else
      raise "Invalid HTTP method"
    end
    handle_response(result)
  end
end
