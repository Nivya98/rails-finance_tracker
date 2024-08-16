class UserStocksController < ApplicationController
  def create
    stock = Stock.check_db(params[:ticker].upcase)
    if stock.blank?
      stock = Stock.new_lookup(params[:ticker].upcase)
      if stock
        stock.save # Save the stock only if it's valid and successfully fetched
      else
        flash[:alert] = "There was an error fetching the stock information."
        redirect_to my_portfolio_path and return
      end
    else
      flash[:notice] = "Stock #{stock.ticker} (#{stock.name}) is already in the database."
      redirect_to my_portfolio_path and return
    end
    @user_stock = UserStock.create(user: current_user, stock: stock )
    flash[:notice] = "Stock #(stock.ticker)#(stock.name)was added"
    redirect_to my_portfolio_path
  end

  def destroy
    stock = Stock.find(params[:id])
    user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id).first
    user_stock.destroy 
    flash[:notice] = "the ticker #{stock.ticker} was successfully removed from portfolio"
    redirect_to my_portfolio_path
  end
end
