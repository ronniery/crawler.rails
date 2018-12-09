require 'application_system_test_case'
require "#{Rails.root}/test/config/config_test_loader"
require 'jwtoken'

# QuotesControllerTest
#
# This class will test the unique path of quotes controller that returns an view, `quotes/:tag/:mode`
# to do that we need first get a token on the application and send on the url the term/tag to search
# on the quotes web site
#
class QuotesControllerTest < ApplicationSystemTestCase

  # Before each test add the mock user on test database
  setup do
    @user = User.new({
                       email: 'yellena@example.com',
                       password: 'horkick'
                     })
    @user.save
  end

  # And after each test remove the mock user
  teardown do
    @user.delete
  end

  test 'should load pretty print editor' do
    visit "/quotes/love/v?t=#{get_valid_token}"

    sleep 1
    assert_selector '#editor'
    assert_selector '#editor .jsoneditor'
    assert_selector '#editor .jsoneditor .jsoneditor-menu'
    assert_selector '#editor .jsoneditor .jsoneditor-navigation-bar'
    assert_selector '#editor .jsoneditor .jsoneditor-outer'
  end

  test 'should load valid quote tag search inside pretty print editor' do
    visit "/quotes/love/v?t=#{get_valid_token}"

    assert_selector '#editor'
    assert_selector '.jsoneditor-tree'
    assert_equal find('table.jsoneditor-tree > tbody').all('tr.jsoneditor-expandable').size, 6
  end

  test 'should load invalid quote tag search inside pretty print editor' do
    visit "/quotes/notag/v?t=#{get_valid_token}"

    assert_selector '#editor'

    sleep 2
    assert_selector 'table.jsoneditor-tree'
    assert_equal find('table.jsoneditor-tree div[contenteditable="true"]').text, 'No results for the given /notag/ tag.'
  end

  private

  def get_valid_token
    # Get a valid token before run the test
    JWToken.encode(id: @user['_id'].to_s)
  end
end
