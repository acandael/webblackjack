require 'rubygems'
require 'sinatra'

set :sessions, true

get '/' do
  erb :home
end

get '/user/profile' do
  erb :"/user/profile"
end


