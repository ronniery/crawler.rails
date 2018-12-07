# frozen_string_literal: true

class QuotesController < ApplicationController
  before_action :set_quotes

  # GET /quotes/*tag
  def show
    render json: @quotes
  end

  private

  # Use callbacks to share common setup or constraints between actions.
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
