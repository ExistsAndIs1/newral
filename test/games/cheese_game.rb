class CheeseGame
  attr_accessor :map_size, :moves
  def initialize 
    @run = 0
    @map_size = 12
    @start_position = 3
    @player_position = @start_position
    reset

    # Clear the console
    puts "\e[H\e[2J"

  end

  def reset
    @player_position = @start_position
    @cheese_x = 10
    @pit_x = 0
    @score = 0
    @run += 1
    @moves = 0
  end


  def run
    while @score < 5 && @score > -5
      draw
      gameloop
      @moves += 1
    end

    # Draw one last time to update the
    draw

    if @score >= 5
      puts "  You win in #{@moves} moves!"
    else
      puts "  Game over"
    end

  end


  # a game must implement these functions
  def set_player( player )
    @player = player
  end 

  def get_actions( player:nil )
    [:left,:right]
  end

  def get_position( player:nil )
    @player_position
  end

  def get_input
    @player.get_input # this is the only place were we need a player
  end

  def get_score( player:nil )
    @score 
  end 
  # a game must implement these  functions

  

  def gameloop
    move = get_input 
    if move == :left
      @player_position = @player_position > 0 ? @player_position-1 : @map_size-1;
    elsif move == :right
      @player_position = @player_position < @map_size-1 ? @player_position+1 : 0;
    end

    if @player_position == @cheese_x
      @score += 1
      @player_position = @start_position
    end

    if @player_position == @pit_x
      @score -= 1
       @player_position = @start_position
    end
  end

  def draw
    # Compute map line
    map_line = @map_size.times.map do |i|
      if  @player_position == i
        'P'
      elsif @cheese_x == i
        'C'
      elsif @pit_x == i
        'O'
      else
        '='
      end
    end
    map_line = "\r##{map_line.join}# | Score #{@score} | Run #{@run}"

    # Draw to console
    # use printf because we want to update the line rather than print a new one
    printf("%s", map_line)
  end
end
