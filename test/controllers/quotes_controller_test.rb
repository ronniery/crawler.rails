# frozen_string_literal: true

require 'test_helper'
require "#{Rails.root}/test/config/config_test_loader"

class QuotesControllerTest < ActionDispatch::IntegrationTest

  test 'should reject access without token on [URL/HEADER]' do
    get '/quotes/love?t='
    assert_response :unauthorized

    json = JSON.parse(response.body)

    pre_assert json

    assert_equal json['message'], 'You need request a token before go ahead.'
  end

  test 'should show unreadable for token on [URL]' do
    get '/quotes/love?t=invalid_token'
    assert_response :unauthorized

    json = JSON.parse(response.body)

    pre_assert json

    assert_equal json['message'], 'Auth token unreadable.'
  end

  test 'should show expired for token on [URL]' do
    get "/quotes/love?t=#{load_expired_token}"
    assert_response :unauthorized

    json = JSON.parse(response.body)

    pre_assert json

    assert_equal json['message'], 'Token has expired.'
  end

  test 'should show invalid for token on [HEADER]' do
    get '/quotes/love', headers: { 'Authorization' => 'Bearer invalid_token' }
    assert_response :unauthorized

    json = JSON.parse(response.body)

    pre_assert json

    assert_equal json['message'], 'Auth token unreadable.'
  end

  test 'should show expired for token on [HEADER]' do
    get '/quotes/love', headers: {
      'Authorization' => "Bearer #{load_expired_token}"
    }
    assert_response :unauthorized

    json = JSON.parse(response.body)

    pre_assert json

    assert_equal json['message'], 'Token has expired.'
  end

  test 'should search empty quote' do
    get "/quotes/?t=#{get_valid_token['token']}"
    assert_redirected_to '/422'
  end

  test 'should successful search quote for word `love`' do
    get "/quotes/love?t=#{get_valid_token['token']}"

    quotes = JSON.parse response.body

    assert_equal quotes.is_a?(Array), true
    assert_equal quotes.length >= 1, true

    first = quotes.first

    assert_equal first['tags'].is_a?(Array), true

    assert_equal first['desc'].is_a?(String), true
    assert_equal first['desc'].empty?, false
    assert_equal first['author_about'].is_a?(String), true
  end

  private

  def load_expired_token
    'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiNWMwYTQ5YzYyYWNmNm'\
    'QxMmYwZWYyNzI4IiwiZXhwIjoxNTQ0MTg1MzE4fQ.tg_0CFkbhD'\
    'y80crnxzI2YjiHNu4L7L3L4CFUpM8PYsc'
  end

  def get_valid_token
    # Get a valid token before run the test
    post '/create', params: ConfigTestLoader.load_test_user
    JSON.parse response.body
  end

  def pre_assert(json)
    assert_not_nil json
    assert_not_empty json
    assert_equal json['message'].is_a?(String), true
    assert_equal json['status'].is_a?(Integer), true
    assert_equal json['status'], 401
  end
end
