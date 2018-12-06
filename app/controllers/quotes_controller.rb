class QuotesController < ApplicationController
  before_action :set_quotes

  # GET /quotes/:tag
  def show
    render json: @quotes
  end

  # POST /quotes
  # def create
  #   @quote = Quote.new(quote_params)

  #   if @quote.save
  #     render json: @quote, status: :created, location: @quote
  #   else
  #     render json: @quote.errors, status: :unprocessable_entity
  #   end
  # end

  # PATCH/PUT /quotes/1
  # def update
  #   if @quote.update(quote_params)
  #     render json: @quote
  #   else
  #     render json: @quote.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /quotes/1
  # def destroy
  #   @quote.destroy
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quotes
      # Find the tag inside the list of tags
      @quotes = Quote.where tags: params[:tag]

      # If nothing was found
      if @quotes.empty?
        # Go get the entire quote list from especific tag
        @quotes = Crawler.get_quotes params[:tag]
      end
    end

    # Only allow a trusted parameter "white list" through.
    def quote_params
      params.require(:quote).permit(:desc, :author, :author_about, :tags)
    end
end
