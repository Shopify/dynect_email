require 'rubygems'
require 'test/unit'
require 'fakeweb'
require 'lib/smart_mta'

FakeWeb.allow_net_connect = false

class Test::Unit::TestCase

  def load_fixture(name)
    File.read(File.dirname(__FILE__) + "/fixtures/#{name}.json")
  end
end
