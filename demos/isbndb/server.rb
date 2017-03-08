# server.rb - Main Sinatra Application
require 'sinatra'
require 'net/http'
require 'uri'
require 'json'

get '/' do
  erb :home
end

# handle search request & talk to the isbndb.com server
post '/' do
  query_string = URI.encode_www_form({q: params[:q]})
  data = Net::HTTP.get(URI.parse("http://isbndb.com/api/v2/json/#{ENV['ISBNDB_API_KEY']}/books?#{query_string}"))
  # did we succeed in getting data back?
  status = (data && data['data']) ? 'ok' : 'error'
  # we're going to return json data
  content_type :json
  p JSON.parse(data)
  ({status: status}).merge(JSON.parse(data)).to_json
end