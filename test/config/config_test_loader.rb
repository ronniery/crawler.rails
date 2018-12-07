# frozen_string_literal: true

class ConfigTestLoader

  def self.load_test_user
    loaded = {
      user: {
        email: 'ömür.ertürk@example.com',
        password: 'kodiak'
      }
    }

    loaded
  end

  def self.load_key(key)
    config[key]
  end

  def self.quote_schema
    schema = "#{Rails.root}/test/config/quote_schema.json"
    JSON.parse File.read schema
  end
end
