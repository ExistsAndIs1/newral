class CheeseGame2d
  attr_accessor :score, :map_size_x, :map_size_y, :cheese_x, :cheese_y, :new_game, :moves, :delay

  def initialize
    @run = 0
    @map_size_x = 10
    @map_size_y = 10
    @start_position = { x:4,y:1 }
    @moves = 0
    @position = @start_position.dup
    reset

    # Clear the console
    puts "\e[H\e[2J"

  end

  def reset
    @position = @start_position.dup
    @cheese_x = 8 #rand(@map_size_x)
    @cheese_y = 6 #rand(@map_size_y)
    @pit_x = 3
    @pit_y = 5
    @score = 0
    @run += 1
    @moves = 0
    @new_game = true
  end

  def run
    while @score < 5 && @score > -5
      draw
      gameloop
      @moves += 1
      sleep @delay if @delay
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
    [:left,:right,:up,:down]
  end

  def get_position( player:nil )
    @position[:x]*map_size_x+@position[:y]
  end

  def get_input
    @moves = @moves+1
    @player.get_input # this is the only place were we need a player
  end

  def get_score( player:nil )
    @score 
  end 
  # a game must implement these  functions

  def gameloop
    move = get_input
    if move == :left
      @position[:x] = @position[:x] > 0 ? @position[:x]-1 : @map_size_x-1;
    elsif move == :right
      @position[:x] = @position[:x] < @map_size_x-1 ? @position[:x]+1 : 0;
    elsif move == :down
      @position[:y] = @position[:y] < @map_size_y-1 ? @position[:y]+1 : 0;
    elsif move == :up
      @position[:y] = @position[:y] > 0 ? @position[:y]-1 : @map_size_y-1;
    end

    if @position[:x] == @cheese_x && @position[:y] == @cheese_y
      @score += 1
      @position = @start_position.dup
      #@cheese_x = rand(@map_size_x)
      #@cheese_y = rand(@map_size_y)
    end

    if @position[:x] == @pit_x && @position[:y] == @pit_y
      @score -= 1
      @position = @start_position.dup
    end

    if @new_game
      @new_game = false # No longer a new game after the first input has been received
    end
  end

  def draw
    # Clear the console
    puts "\e[H\e[2J"
    #puts ""

    puts "Score #{@score} | Run #{@run}\n"
    puts "############"
    # Compute map line
    @map_size_y.times.each do |y|
      map_line = @map_size_x.times.map do |x|
        if @position[:x] == x && @position[:y] == y
          'P'
        elsif @cheese_x == x && @cheese_y == y
          'C'
        elsif @pit_x == x && @pit_y == y
          'O'
        else
          '='
        end
      end
      # Draw to console
      puts "##{map_line.join}#"
    end
    puts "############"
  end

end