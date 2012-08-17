require 'httparty'
require 'ostruct'
module DynectEmail
  class Error < StandardError; end

  include HTTParty
  # debug_output $stderr
  base_uri 'http://emailapi.dynect.net/rest/json'
  class << self
    attr_accessor :api_key
  end

  # senders

  def self.add_sender(email, apikey=nil)
    post_data("/senders", {:emailaddress => email}, apikey)
  end

  def self.remove_sender(email, apikey=nil)
    post_data("/senders/delete", {:emailaddress => email}, apikey)
  end

  # accounts

  def self.add_account(username, password, company, phone, options={})
    post_data("/accounts", options.merge({:username => username, :password => password, :companyname => company, :phone => phone}))
  end

  def self.remove_account(username)
    post_data("/accounts/delete", :username => username)
  end

  # reports/bounces

  def self.get_bounces_count(options = {})
    get_data("/reports/bounces/count", options)
  end

  def self.get_bounces(options = {})
    get_data("/reports/bounces", options)
  end

  # suppressions

  def self.get_suppressions_count(options = {})
    get_data("/suppressions/count", options)
  end

  def self.get_suppressions(options = {})
    get_data("/suppressions", options)
  end

  def self.activate_suppression(email)
    post_data("/suppressions/activate", :emailaddress => email)
  end

  # {:xheader1 => "X-header", xheader2 => ....}
  def self.set_headers(headers, apikey=nil)
    post_data("/accounts/xheaders", headers, apikey)
  end

  private
  def self.handle_response(response)
    message = response['response']['message']
    raise DynectEmail::Error, message unless message == 'OK'
    response['response']['data']
  end

  def self.post_data(url, options={}, apikey=nil)
    options.merge!(:apikey => apikey || DynectEmail.api_key)
    result = post(url, :body => options)

    handle_response(result)
  end

  def self.get_data(url, options={}, apikey=nil)
    options.merge!(:apikey => apikey || DynectEmail.api_key)
    result = get(url, :query => options)

    handle_response(result)
  end
end
