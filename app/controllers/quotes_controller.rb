# frozen_string_literal: true

# QuotesController
#
# Core application that will serve routes to user search a term and returns the response as JSON
# or with other route pretty print the response inside html component viewer
#
class QuotesController < ApplicationController
  before_action :set_quotes

  # GET /quotes/:tag
  def show
    render json: @quotes
  end

  # GET /quotes/:tag/:mode
  def viewer
    @quotes
    @tag = params[:tag]
  end

  private

  # Set the quotes to this controller
  def set_quotes
    redirect_to '/422' if params[:tag].blank?

    # Find the tag inside the list of tags
    @quotes = Quote.where tags: params[:tag]

    # If nothing was found
    if @quotes.empty?
      # Go get the entire quote list from specific tag
      @quotes = Crawler.get_quotes params[:tag]
    end
  end

end
