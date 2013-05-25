require 'rubygems'
require 'sinatra'
require 'sinatra/flash'
require 'pry'

set :sessions, true

BLACKJACK_AMOUNT = 21
DEALER_HIT_MIN = 17



get '/' do
  if session[:player_name]
    session[:player_credit] = 500
    session[:bet_amount] = 0
    session[:player_cards] = nil    
    redirect '/game'
  else
    redirect '/new_player'
  end
end

get '/new_player' do
  erb :new_player
end

post'/new_player' do
  session[:player_name] = params[:player_name]
  
  redirect '/game'
end

get '/game' do
  
  if !session[:player_cards]
    suits = ['H', 'D', 'S', 'C']
  values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  session[:deck] = suits.product(values).shuffle!
  
  session[:dealer_cards] = []
  session[:player_cards] = []
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  end

  

  erb :game
end

post '/hit' do
  bet_amount = params[:place_bet].to_i
  session[:bet_amount] = bet_amount
  session[:player_credit] -= bet_amount
  session[:player_cards] << session[:deck].pop
  total = total(session[:player_cards])
  if total > BLACKJACK_AMOUNT
  @error = "sorry your busted"
  end

  # check if bust

  redirect '/game'
end

helpers do

  def to_image(card)
  suit = card[0].to_s
  value = card[1].to_s

  case suit
  when "H"
    suit = "hearts"
  when "D"
    suit = "diamonds"
  when "S"
    suit = "spades"
  when "C"
    suit = "clubs"
  end

  case value
  when "J"
    value = "jack"
  when "Q"
    value = "queen"
  when "K"
    value = "king"
  when "A"
    value = "ace"
  end
  "#{suit}_#{value}.jpg"
  end

  def total(cards)
    # [['H', '3'], ['S', 'Q'], ... ]
    arr = cards.map{|e| e[1] }

    total = 0

    arr.each do |value|
      if value == "A"
        total += 11
      elsif value.to_i == 0 # J, Q, K
        total += 10
      else
        total += value.to_i
      end
    end

    #correct for Aces
    arr.select{|e| e == "A"}.count.times do
      total -= 10 if total > 21
    end
    total
  end

  def blackjack_or_bust?(total)
    if total == BLACKJACK_AMOUNT
    "congratulations, you hit blackjack"
    elsif total > BLACKJACK_AMOUNT
    "sorry your busted!"
    end
  end

end #end helpers






