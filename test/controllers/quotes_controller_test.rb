# frozen_string_literal: true

require 'test_helper'

class QuotesControllerTest < ActionDispatch::IntegrationTest

  test 'should reject access without token on [URL/HEADER]' do
    get '/quotes/love?t='
    assert_response :unauthorized

    json = JSON.parse(response.body)

    pre_assert json

    assert_equal json['message'], 'You need request a token before go ahead.'
  end

  test 'should show unreadable for token on [URL]' do
    get '/quotes/love&t=invalid_token'
    assert_response :unauthorized

    json = JSON.parse(response.body)

    pre_assert json

    assert_equal json['message'], 'Auth token unreadable.'
  end

  test 'should show expired for token on [URL]' do
    get load_expired_token
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
    get '/quotes/love', headers: { 'Authorization' => "Bearer #{load_expired_token}" }
    assert_response :unauthorized

    json = JSON.parse(response.body)

    pre_assert json

    assert_equal json['message'], 'Token has expired.'
  end

  private

  def load_expired_token
    path = "#{Rails.root}/expired_token.yml"
    loaded = YAML.load_file path

    "/quotes/love&t=#{loaded['expired_token']}"
  end

  def pre_assert(json)
    assert_not_nil json
    assert_not_empty json
    assert_equal json['message'].is_a?(String), true
    assert_equal json['status'].is_a?(Integer), true
    assert_equal json['status'], 401
  end

end
