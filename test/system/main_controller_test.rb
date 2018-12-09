require 'application_system_test_case'

# MainControllerTest
#
# Execute system tests over the main path '/' validating the expected behavior for some components
# that uses javascript code to run some actions on page.
class MainControllerTest < ApplicationSystemTestCase

  # Time to wait before continue the tests for token creation
  TOKEN_WAIT = 3

  # Time to wait until auto fill the inputs on the page
  AUTO_FILL_WAIT = 5

  setup do
    # Before each test go to '/' path
    visit '/'
  end

  test 'viewing home path' do
    assert_selector '.card.fat'
  end

  test 'should inputs disabled when page loads' do
    assert_disabled_inputs
  end

  test 'should inputs filled automatically after load' do
    sleep AUTO_FILL_WAIT

    assert_equal find('[id="email"]').value.include?('@example.com'), true
    assert_equal !find('[id="password"]').value.empty?, true
  end

  test 'should tooltips visible after mouse hover elements' do
    # Remember-me tooltip
    begin
      page.find("[for='remember']").hover

      # If is visible after hover
      assert_selector :css, '.tooltip'
      assert_tooltip_text 'Don\'t trust that i will remember you 😏'
    end

    # Forgot password tooltip
    begin
      page.find("[for='password'] a").hover

      assert_selector :css, '.tooltip'
      assert_tooltip_text 'Ok, now we have a problem!'
    end

    begin
      page.find(".account-create a").hover

      assert_selector :css, '.tooltip'
      assert_tooltip_text 'Sorry you can\'t create an account 😕'
    end

  end

  test 'should our endpoints visible after expansor click' do
    assert_hidden_element '.list-api'

    expand_endpoints

    assert_selector '.list-api'

  end

  test 'should term inputs equals' do
    term = 'love'

    expand_endpoints

    find('#quote-term').set term

    assert_equal find('#quote-term-v').value, term
  end

  test 'should token inputs equals' do
    sleep AUTO_FILL_WAIT # Wait auto fill form

    expand_endpoints

    find('button[type="submit"]').click

    sleep TOKEN_WAIT + 2

    assert_equal find('#quote-token-v').value, find('#quote-token').value
  end

  test 'should password visible after pass-eye click' do
    sleep AUTO_FILL_WAIT # Wait auto fill form
    assert_selector 'input[id="password"][type="password"]'

    find('#passeye-toggle').click

    assert_selector 'input[id="password"][type="text"]'
  end

  test 'should show popup with registered token' do
    sleep AUTO_FILL_WAIT # Wait auto fill form

    assert_hidden_element '#modal-token'

    find('button[type="submit"]').click

    assert_disabled_inputs
    assert_selector 'button[type="submit"][disabled]'

    sleep TOKEN_WAIT # Wait until token creation on server

    assert_selector :css, '#modal-token'

  end

  test 'should check visible popup elements' do
    textarea = '.modal-body textarea'

    sleep AUTO_FILL_WAIT # Wait auto fill form

    find('button[type="submit"]').click

    sleep TOKEN_WAIT # Wait until token creation on server

    assert_selector '.modal-body'
    assert_selector textarea
    assert_equal find(textarea).value.empty?, false
    assert_equal find(textarea).value.length >= 120, true

    find('#modal-token .btn-copy-close').click

    assert_hidden_element '#modal-token'
  end

  test 'should the links are the same' do
    expand_endpoints
    find('#quote-token').set 'dummy-token'
    find('#quote-term').set 'love'

    base_path = "#{page.config.app_host}:#{page.server.port}"
    assert_equal find('#quote-route')[:href], "#{base_path}/quotes/love?t=dummy-token"
    assert_equal find('#quote-route-v')[:href], "#{base_path}/quotes/love/v?t=dummy-token"
  end

  private

  # Assert when the given element is hidden on the test
  def assert_hidden_element(selector)
    assert_selector :css, selector, visible: :hidden
  end

  # Assert the disable inputs for the page loaded on chrome driver
  def assert_disabled_inputs
    assert_selector 'input[id="email"][disabled]'
    assert_selector 'input[id="password"][disabled]'
  end

  # Assert the text for a shown tooltip, checking if the given text is the same on the tip
  def assert_tooltip_text(text)
    assert_equal page.find(".tooltip").text, text
  end

  # Expand the endpoints on page. note: See the page on '/' to understand what is this behavior.
  def expand_endpoints
    find(".card-expander > div").click
  end

end
