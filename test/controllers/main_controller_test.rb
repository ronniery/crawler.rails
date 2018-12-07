# frozen_string_literal: true

require 'test_helper'
require 'jwtoken'
require "#{Rails.root}/test/config/config_test_loader"

class MainControllerTest < ActionDispatch::IntegrationTest

  test 'should get index' do
    get '/'
    assert_response :success
  end

  test 'should see token page' do
    get '/'
    assert_select 'div.card.fat'
    assert_select 'h4.card-title', 'Auth token'
    assert_select 'h4.card-title + hr'
    assert_select 'label[for="email"]', 'E-mail'
    assert_select 'input[id="email"]'
    assert_select 'label[for="password"]'
    assert_select 'label[for="password"] a', 'Forgot password?'
    assert_select 'div#eye-password > input[id="password"]'
    assert_select 'div#eye-password > div#passeye-toggle', 'Show'
    assert_select 'input#remember'
    assert_select 'label[for="remember"]', 'Remember me'
    assert_select 'button#get-token', 'Get token'
    assert_select 'form > div:last-child', 'Don\'t have an account? Create One'
    assert_select 'form > div:last-child a', 'Create One'
  end

  test 'should api endpoints are at page' do
    get '/'
    assert_select 'ul.list-api'
    assert_select 'li:nth-child(1)', 'Our API'
    assert_select 'li:nth-child(2)', 'quotes//' # this is the raw text
    assert_select 'li:nth-child(2) > input.search-term'
    assert_select 'li:nth-child(2) > input.token'
    assert_select 'li:nth-child(2) > a'
    assert_select 'li:nth-child(3)', 'quotes///v' # this is the raw text
    assert_select 'li:nth-child(3) > input.search-term'
    assert_select 'li:nth-child(3) > input.token'
    assert_select 'li:nth-child(3) > a'
    assert_select '.card-expander', 'Endpoints'
  end

  test 'should returns jwt api token' do
    post '/create', params: ConfigTestLoader.load_test_user

    assert_response :success

    json = JSON.parse response.body
    token = json['token']

    assert_not_nil token
    assert_not_empty token
    assert_equal token.is_a?(String), true
    assert_equal token.mb_chars.length >= 125, true
    assert_equal JWToken.decode(token).blank?, false
  end
end
