require 'test_helper'
require 'socket'
require 'resolv-replace'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1024, 768]
end
