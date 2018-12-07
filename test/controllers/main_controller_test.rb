require 'test_helper'

class MainControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get '/'
    assert_response :success
  end

  test 'can see token page' do
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
    assert_select 'form > div:last-child', 'Don\'t have an account?'
    assert_select 'form > div:last-child a', 'Create One'
  end

  test 'api endpoints are at page' do
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
  end

end
