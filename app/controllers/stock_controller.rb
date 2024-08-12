class StockController < ApplicationRecord
  def search
    @stock = Stock.new_lookup(params[:ticker])
    #render json: @stock
  end
  
end