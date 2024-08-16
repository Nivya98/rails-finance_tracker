class Stock < ApplicationRecord
  require 'httparty'
  require 'json'

  has_many :user_stocks
  has_many :users, through: :user_stocks
  validates :name, :ticker, presence: true 


  def self.new_lookup(ticker_symbol)
    begin
      api_key = Rails.application.credentials.key
      url = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=#{ticker_symbol}&apikey=#{api_key}"
      
      response = HTTParty.get(url)
      parsed_response = JSON.parse(response.body) 
      
      time_series = parsed_response["Time Series (Daily)"]
      if time_series
        latest_date = time_series.keys.first
        closing_price = time_series[latest_date]["4. close"]
        stock = new(ticker: ticker_symbol, last_price: closing_price) # since we are  using self. which is a class method we just give new insied creates a new instance of a stock class , self.new: When you call new inside a class method without explicitly specifying the class name, Ruby implicitly understands it as self.new. Since self refers to the Stock class in this context, new is equivalent to Stock.new.Inside this class method, when you write new(...), it implicitly calls Stock.new(...) because self inside the class method refers to the Stock class.
        #stock = Stock.new(ticker: ticker_symbol, last_price: closing_price) # creating a class obkect bith above code nd this code will work the same 
        #puts "The closing price for #{ticker_symbol} on #{latest_date} was $#{closing_price} data_dassed #{stock.last_price}"
        return stock
        #puts "#{stock}"
      else
        #puts "Error fetching data for #{ticker_symbol}. Please check the symbol and try again."
        return nil
      end
    rescue => exception
      puts "An error occurred: #{exception.message}"
      return nil
    end
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol ).first
    # actually it is stocks.where(ticker:"GOOGL" ).first , bur since ot is a self method we are not specifyng the stock bcz im already inside the stock model 
  end
  # returns the stock object if it exist in the table 
end
