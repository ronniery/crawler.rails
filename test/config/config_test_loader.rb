# frozen_string_literal: true

# ConfigTestLoader
#
# Container of config items to be used inside the tests
#
class ConfigTestLoader

  # Load a default dummy user
  def self.load_test_user
    loaded = {
      user: {
        email: 'ömür.ertürk@example.com',
        password: 'kodiak'
      }
    }

    loaded
  end

  # Loads configuration for the given key
  #
  # @param {string} key The key name to load a configuration
  def self.load_key(key)
    config[key]
  end
end
