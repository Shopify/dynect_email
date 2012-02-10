require 'httparty'
require 'ostruct'
module DynectEmail
  class Error < StandardError; end

  include HTTParty
  base_uri 'http://emailapi.dynect.net/rest/json'
  class << self
    attr_accessor :api_key
  end

  def self.add_sender(email, apikey=nil)
    post_data("/senders", {:emailaddress => email}, apikey)
  end

  def self.remove_sender(email, apikey=nil)
    post_data("/senders/delete", {:emailaddress => email}, apikey)
  end

  def self.add_account(username, password, company, phone, options={})
    post_data("/accounts", options.merge({:username => username, :password => password, :companyname => company, :phone => phone}))
  end

  def self.remove_account(username)
    post_data("/accounts/delete", :username => username)
  end

  def self.send(params, apikey=nil)
    post_data("/send", params, apikey)
  end

  # {:xheader1 => "X-header", xheader2 => ....}
  def self.set_headers(headers, apikey=nil)
    post_data("/accounts/xheaders", headers, apikey)
  end

  private
  def self.handle_response(response)
    message = response['response']['message']
    data = response['response']['data']
    # Dynect will still return a message of OK but a data status code of 4xx or 5xx
    raise DynectEmail::Error, "#{message}: #{data}" if data.is_a?(String) && (data.start_with?("4") || data.start_with?("5"))
    raise DynectEmail::Error, "#{message}: #{data}" unless message == 'OK'
    response['response']['data']
  end

  def self.post_data(url, options={}, apikey=nil)
    options.merge!(:apikey => apikey || DynectEmail.api_key)
    result = post(url, :body => options)

    handle_response(result)
  end
end
