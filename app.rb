require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || HangpersonGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    
    @game = HangpersonGame.new(word)
    redirect '/show'
  end
  
  # Use existing methods in HangpersonGame to process a guess.
  post '/guess' do
    letter = params[:guess].to_s[0]
    
    if letter !~ /[[:alpha:]]/ 
      flash[:message] = "Invalid guess."
    elsif (@game.guesses.include? letter or @game.wrong_guesses.include? letter)
      flash[:message] = "You have already used that letter."
    else
      @game.guess(letter)
    end 
    
    redirect '/show'
  end
  
  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in HangpersonGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  
  get '/show' do
    ### YOUR CODE HERE ###
    @game.word_with_guesses
    
    if @game.str == @game.word and @game.wrong_guesses.length < 7
      redirect '/win'
    elsif @game.wrong_guesses.length >= 7
      redirect '/lose'
    else
      erb :show   
    end
    
  end
  
  get '/win' do
    ### YOUR CODE HERE ###
    if @game.str == @game.word and @game.wrong_guesses.length < 7
      erb :win 
    else 
      redirect '/show'
    end
  end
  
  get '/lose' do
    ### YOUR CODE HERE ###
    if @game.wrong_guesses.length >= 7 
      erb :lose
    else 
      redirect '/show'
    end
  end

end