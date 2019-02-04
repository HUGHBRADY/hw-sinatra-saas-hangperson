class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  attr_accessor :word, :guesses, :wrong_guesses, :str
  
  def initialize(word)
    @word = word 
    @guesses = ""
    @wrong_guesses = ""
  end
  
  def guess(g)
    
    if g =~ /[[:alpha:]]/
    
      g.downcase!
      
      if @word.include? g and !@guesses.include? g
         @guesses << g
      elsif !@word.include? g and !@wrong_guesses.include? g
        @wrong_guesses << g
      else 
        return false
      end
    
    else
      raise ArgumentError
    end
  
  end

  def word_with_guesses
    
    @str = ""
    
    @word.chars.each do |x|
      if @guesses.include? x
        @str << x
      else
        @str << "-"
      end 
    end
      
    return @str
    
  end
  
  def check_win_or_lose 
    
    word_with_guesses
    
    if str == word
      return :win
    elsif wrong_guesses.length >= 7
      return :lose
     
    else 
      return :play
    end 
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
