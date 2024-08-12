require 'httparty'# ths is a library used to handel the http request and api response from the 'alphavantage' server 

class HomeController < ApplicationController
  def index
    if params[:ticker].present?
      #api_key = Rails.application.credentials.api_key
      #api_key = 'F009IOZS5G0I074Z'
      #api_key = Rails.application.credentials.key[:api_key]
      api_key = Rails.application.credentials.key
      #Rails.logger.debug "API Key: #{api_key.inspect}"
      ticker = params[:ticker]
      url = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=#{ticker}&apikey=#{api_key}"
      #url = 'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=IBM&apikey=demo'
      response = HTTParty.get(url) # sending http get request to the above url 
      @stock_data = response.parsed_response #parsed_response in HTTParty is used to automatically parse the response body into a Ruby data structure based on the content type of the response.
      #f the server returns JSON, parsed_response will automatically parse it into a Ruby hash or array.
      #@stock_data: Stores the parsed data, making it available for use in your Rails views.
    else
      @message = "Please enter a ticker symbol"
    end
  end
end

# so when we want ant data we sent a http het request to the server that has al the required data using that specific servers api key/api token and gets the response
#.get: This is the method provided by HTTParty to send a GET request. It is responsible for making the actual HTTP request to the server.so it gets and store in this variable "response" 