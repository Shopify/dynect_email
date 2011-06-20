require 'test_helper'

class DynECTEmailTest < Test::Unit::TestCase

  def setup
    DynECTEmail.api_key = "12345"
  end

  def teardown
    FakeWeb.allow_net_connect = false
  end

  def test_missing_or_invalid_api_key
    DynECTEmail.api_key = ""
    FakeWeb.register_uri(:post, "http://emailapi.dynect.net/rest/json/senders", :body => load_fixture('missing_or_invalid_api_key'), :status => 451, :content_type => "text/json")

    DynECTEmail.api_key = ""
    error = assert_raise DynECTEmail::Error do
      result = DynECTEmail.add_sender("test@example.com")
    end

    assert_equal "Missing or Invalid API Key", error.message
  end

  def test_missing_or_invalid_field
    FakeWeb.register_uri(:post, "http://emailapi.dynect.net/rest/json/accounts", :body => load_fixture('missing_or_invalid_fields'), :status => 451, :content_type => "text/json")

    error = assert_raise DynECTEmail::Error do
      DynECTEmail.add_account("test@example.com", "test", nil, nil)
    end

    assert_equal "Missing or Invalid Required Fields", error.message
  end

  def test_add_account
    FakeWeb.register_uri(:post, "http://emailapi.dynect.net/rest/json/accounts", :body => load_fixture('ok'), :status => 200, :content_type => "text/json")

    response = DynECTEmail.add_account("test@example.com", "test", "Shopify", "1231231234")

    assert_equal "1234", response['apikey']
  end

  def test_add_sender
    FakeWeb.register_uri(:post, "http://emailapi.dynect.net/rest/json/senders", :body => load_fixture('ok'), :status => 200, :content_type => "text/json")

    assert_nothing_raised do
      DynECTEmail.add_sender("test@example.com")
    end
  end

  def test_add_sender_duplicate
    FakeWeb.register_uri(:post, "http://emailapi.dynect.net/rest/json/senders", :body => load_fixture('object_already_exists'), :status => 453, :content_type => "text/json")

    error = assert_raise DynECTEmail::Error do
      DynECTEmail.add_sender("test@example.com")
    end

    assert_equal "Object Already Exists", error.message
  end

  def test_add_sender_with_apikey
    FakeWeb.register_uri(:post, "http://emailapi.dynect.net/rest/json/senders", :body => load_fixture('ok'), :status => 200, :content_type => "text/json")

    assert_nothing_raised do
      DynECTEmail.add_sender("test@example.com", "123")
    end
  end

  def test_remove_sender
    FakeWeb.register_uri(:post, "http://emailapi.dynect.net/rest/json/senders/delete", :body => load_fixture('ok'), :status => 200, :content_type => "text/json")

    assert_nothing_raised do
      DynECTEmail.remove_sender("test@example.com")
    end
  end

  def test_remove_account
    FakeWeb.register_uri(:post, "http://emailapi.dynect.net/rest/json/accounts/delete", :body => load_fixture('ok'), :status => 200, :content_type => "text/json")

    assert_nothing_raised do
      DynECTEmail.remove_account("test@example.com")
    end
  end

  def test_set_headers
    FakeWeb.register_uri(:post, "http://emailapi.dynect.net/rest/json/accounts/xheaders", :body => load_fixture('ok'), :status => 200, :content_type => "text/json")

    assert_nothing_raised do
      DynECTEmail.set_headers({:xheader1 => "X-Sample1", :xheader2 => "X-Sample2"})
    end
  end
end
