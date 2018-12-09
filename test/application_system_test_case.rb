require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium_chrome, using: :chrome, screen_size: [1024, 768]
end
