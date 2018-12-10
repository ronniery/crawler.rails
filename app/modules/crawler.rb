# frozen_string_literal: true

#
# Simple module crawler to get all quotes from given target `quotes.toscrape`, after that
# the same class will parse the entire html received for tag request and transforms the
# html string to a list/array of Quotes.
#
class Crawler

  # Get the list of quotes for given tag
  def self.get_quotes(tag)
    html = get_page(tag)

    parse_quotes(html)
  end

  private_class_method

  # Send request to get full HTML page from quotes to given tag
  def self.get_page(tag)
    Excon.get("http://quotes.toscrape.com/tag/#{tag}/").body
  end

  # Extract a list of quotes from html string
  def self.parse_quotes(html)
    quotes = []

    # Loads the html string inside the parser
    page = Nokogiri::HTML html
    # Select ALL div.quote from doc
    page.css('.quote').each do |node|
      # For every quote[doc] parse the content on it
      quote = Quote.new(
        desc: node.css('span.text').first.text,
        author: node.css('small.author').first.text,
        author_about: "http://quotes.toscrape.com#{node.css('small.author + a').first['href']}",
        tags: node.css('.tags a.tag').map(&:text)
      )

      # Try save...
      if quote.save
        # If success add the parsed quote on the list
        quotes.push quote
      else
        # Or else show the error
        puts quote.errors
      end
    end

    quotes
  end
end
