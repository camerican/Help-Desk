require 'sinatra'
require 'httparty'
require 'json'

get '/' do
  erb :index
end
post '/' do
  response = HTTParty.get("http://www.thecocktaildb.com/api/json/v1/1/filter.php?i=#{params[:ingredient]}")
  if response && response.body 
    @results = JSON.parse(response.body)["drinks"]
  else
    @results = nil
  end
  # the results are oddly formatted, so we have to access an array of 
  # results via a "drinks" key on the object that is returned
  erb :index
end

