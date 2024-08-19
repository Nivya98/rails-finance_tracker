class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
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
  def under_stock_limit?
    stocks.count < 10
  end
  
  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end
  
  def full_name 
    return "#{first_name} #{last_name}" if first_name || last_name 
    "Anonymous"
  end

  def self.search(param)
    param.strip!
    to_send_back = (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
    return nil unless to_send_back
    to_send_back
  end

  def self.first_name_matches(param)
    matches("first_name",param)
  end

  def self.last_name_matches(param)
    matches("last_name", param)
  end

  def self.email_matches(param)
    matches("email", param)
  end

  def self.matches(field_name, param)
    where("#{field_name} like?", "%#{param}%")
  end

  def exclude_current_user(users)
    users.reject { |user| user.id == self.id } 
  end
    
  def not_friend_with?(id_of_friend)
    !self.friends.where(id: id_of_friend).exists?
  end
end 
