class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # if the user is alredy tracking the stock, we want to check if the stock being tracked falls winth the (9 stocks only condition)
  # we want to check if the stock that is passed in "can_track_stock?"method is already been tracked by ths  user
  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol) # checks if this stockis presen in the table
    return false unless stock
    stocks.where(id: stock.id).exists? 
    #since it is alredy a user model we dont need to use user.stocks.where(id: 3).exists?
  end
  # to display only 9 stocks for a user :- user: User.first,   user.stocks.count <10
  def user_stock_limit?
    stocks.count < 10
  end
  def can_track_stock?(ticker_symbol)
    user_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end
end 
