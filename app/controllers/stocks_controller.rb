class StocksController < ApplicationController
  def search
    if params[:ticker].present?
      @stock = Stock.new_lookup(params[:ticker])
      if @stock 
        render 'users/my_portfolio'
      else
        flash[:alert] = "Stock not found. Please check the ticker symbol and try again with a valid symbol."
        redirect_to my_portfolio_path 
      end
    else
      flash[:alert] = "Please enter a symbol to search"
      redirect_to my_portfolio_path 
    end
      
  end
  
end
