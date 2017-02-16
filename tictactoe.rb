class Board
  attr_reader :players,  :squares
  Player = Struct.new(:name, :character)
  Square = Struct.new(:location, :value)

  #Populate the board with squares and create two players
  def initialize()
    populate_squares
    @players = []
    @players << collect_player_info("one")
    @players << collect_player_info("two")
    @rows = [
      [0,1,2],
      [3,4,5],
      [6,7,8]
    ]
    @columns = [
      [0,3,6],
      [1,4,7],
      [2,5,8]
    ]
    @diagonals = [
      [0,4,8],
      [6,4,2]
    ]
    @win_conditions = [@rows,@columns,@diagonals]
  end

  def begin_game
    turn = 0
    while @squares.detect{|square| !square.value}
      active_player = @players[turn%2]
      self.draw_board
      play_turn(active_player)
      if has_won?
        puts "#{active_player.name} has won the game!"
        break
      end
      turn += 1
    end
    self.draw_board
    puts "The game has now completed"
  end

  def has_won?
    @win_conditions.each do |condition| #by rows,columns,or diagonals
      condition.each do |set|
        return true if all_same_values?(set)
      end
    end
    return false
  end

  def all_same_values?(locations)
    squares_at_locations = @squares.select{|square| locations.include? square.location.to_i}
    if all_have_values?(squares_at_locations)
      test_value = squares_at_locations[0].value
      squares_at_locations.each do |square|
        return false unless test_value == square.value
      end
      return true
    end
    return false
  end

  #returns true if all the squares in the given array have a value and false otherwise
  def all_have_values?(some_squares)
    some_squares.each do |square|
      return false unless square.value
    end
    return true
  end

  def play_turn(player)
    puts "#{player.name}: Select a square to play"
    location = gets.chomp
    until legal_move?(location)
      puts "That move is not allowed. Try again"
      location = gets.chomp
    end
    play_square(location, player)
  end

  def create_player(name, char)
    @players << Player.new(name, char)
  end

  def collect_player_info(temp_name)
    puts "Who is player #{temp_name}?"
    player = gets.chomp
    puts "What is their weapon of choice?"
    character = gets.chomp
    Player.new(player, character)
  end

  def inspect
    puts "-------Here are the contenders-----------"
    @players.each do |player|
      puts "#{player.name} wielding '#{player.character}'"
    end
    puts "-------And here is your battlefield------"
    self.draw_board
  end

  #Draws the board onto the terminal
  def draw_board
    @squares.each do |square|
      print " #{square.value ? " #{square.value} " : "[#{square.location}]"} "
      if square.location.to_i % 3 == 2 && square.location.to_i != 8
        print "\n"
        puts "------------------\n"
      elsif square.location.to_i == 8
        print "\n"
      else
        print"|"
      end
    end
  end

  #Changes the value of a square to the character of the player given. Square is choosen by location. Returns false if the value cannot be changed
  def play_square(location,player)
    square = find_square(location)
    square.value=(player.character)
  end

  def legal_move?(location)
    square = find_square(location)
    if location.to_i < 0 || location.to_i > 8
      return false
    elsif square.value
      return false
    else
      return true
    end
  end

private
  #Populates the initial array of sqares when the board is first created
  def populate_squares
    @squares = []
    (0..8).each do |num|
      @squares << Square.new(num.to_s)
    end
  end

  def create_players(player1_name, player1_char, player2_name, player2_char)
    @players << Player.new(player1_name, player1_char)
    @players << Player.new(player2_name, player2_char)
  end

  def find_square(location)
    @squares.detect{|square| square.location.to_i == location.to_i}
  end
  #Draws the current board onto the command line


end

tictactoe_board = Board.new
tictactoe_board.begin_game
