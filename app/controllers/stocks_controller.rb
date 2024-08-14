class StocksController < ApplicationController
  def search
    if params[:ticker].present?
      @stock = Stock.new_lookup(params[:ticker])
      if @stock 
        render 'users/my_portfolio'
        #respond_to do |format|
        #  format.js { render partial: 'users/result' }
        #  format.html { render partial: 'users/result' }
        #end     
      else
        flash.now[:alert] = "Stock not found. Please check the ticker symbol and try again with a valid symbol." 
        redirect_to my_portfolio_path 
        #respond_to do |format|
         # flash.now[:alert] = "Stock not found. Please check the ticker symbol and try again with a valid symbol."
         # format.js { render partial: 'users/result' }
        #end
      end 
    else
      flash.now[:alert] = "Please enter a symbol to search"
      redirect_to my_portfolio_path 
      #respond_to do |format|
       # flash.now[:alert] = "Please eneter a valid symbol to search."
       # format.js { render partial: 'users/result' }
      #end 
    end  
  end 
end
