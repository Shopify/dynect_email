require 'httparty'
require 'ostruct'
module SmartMta
  class Error < StandardError; end

  include HTTParty
  base_uri 'http://smartmta.sendlabs.com/rest/json'
  class << self
    attr_accessor :api_key
  end

  def self.add_sender(email)
    result = post("/senders", :body => { :apikey => SmartMta.api_key, :emailaddress => email })
    message = result['response']['message']
    raise SmartMta::Error, message unless message == 'OK'
    message
  end

  def self.add_account(username, password, company, phone, options={})
    data = options.merge(:apikey => SmartMta.api_key, :username => username, :password => password, :companyname => company, :phone => phone)
    result = post("/accounts", :body => data)
    message = result['response']['message']
    raise SmartMta::Error, message unless message == 'OK'

    OpenStruct.new(data.merge(:apikey => result['response']['data']['apikey']))
  end
end
