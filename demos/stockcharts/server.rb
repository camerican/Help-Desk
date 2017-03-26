# server.rb

require 'sinatra'
require 'net/http'

get '/' do
  @stock = params[:s] && params[:s].length > 0 ? @params[:s].upcase : nil
  erb :home
end

# we use the following route as a proxy to retrieve and pass along Yahoo stock data
get '/stock/:stock' do
  @stock = params[:stock].upcase
  halt 500 unless @stock && @stock.length > 0
  content_type :csv
  uri = URI( 'http://chart.finance.yahoo.com/table.csv' )
  uri.query = URI.encode_www_form(
    s: @stock,        # s - stock symbol to look up
    a: 6,             # a - start month
    b: 1,             # b - start day
    c: 2016,          # c - start year
    d: 3,             # d - end month
    e: 30,            # e - end day
    f: 2017,          # f - end year
    g: 'd',           # g - d (daily), m (monthly), y (yearly)
    ignore: '.csv'
  )
  Net::HTTP.get_response( uri ).body
end