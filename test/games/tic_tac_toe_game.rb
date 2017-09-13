class TicTacToeGame 
 attr_accessor :delay
 attr_reader :draws_reached
  def initialize( width: 3, height: 3, in_a_row: 3, delay: 0 )
    @map = [([-1]*width)]*height
    @in_a_row = in_a_row
    @players = []
    @delay = delay
    reset( reset_score: true )
  end 

  def reset( reset_score: false )
    puts "reset"
    @players_turn = rand(1)
    if reset_score
      @run=0
      @players_score = [0,0]
      @moves = 0
      @draws_reached = 0
    end 
    @run = @run+1
    @map.collect! do |row|
      row.collect { |e| -1 }
    end 
  end 


  def set_player( player )
    @players << player 
  end 

  def get_actions( player: nil )
    free_fields = []
    @map.each_with_index do |row,row_idx|
      row.each_with_index do |el,el_idx|
        free_fields << [row_idx,el_idx] if el == -1
      end 
    end
    # puts "player: #{player} gets actions"+ free_fields.collect{ |x| x.join(':') }.join(', ')
    free_fields 
  end

  def get_position( player: nil ) # transforms field in a unique number
    position = 0 
    @map.each_with_index do |row,row_idx|
      row.each_with_index do |el,el_idx|
        position = position + 2**(row_idx*row.size+el_idx) if @map[ row_idx][ el_idx] == 0
        position = position + 2**((@map.size+row_idx)*row.size+el_idx) if @map[ row_idx][ el_idx] == 1
      end 
    end 
    position
  end

  def get_input
    player = @players[ @players_turn % 2 ]
    input = player.get_input # this is the only place were we need a player
    raise "Not Possible player #{ @players_turn % 2  } tries #{input} #{draw} #{ @map[input[0]][input[1]] } " if  @map[input[0]][input[1]] != -1 # impossible field
    @map[input[0]][input[1]] = @players_turn % 2
    # puts "playing #{ input } #{ @map[input[0]][input[1]] } #{ @players_turn }"
    @players_turn = @players_turn+1
  end

  def get_score( player: nil )
     player == @players[0] ? @players_score[ 0 ] :  @players_score[ 1 ]
  end

  # no fields left?
  def check_draw_reached
    get_actions.empty?
  end 

  def check_winner_diagonal
     @players.size.times do |player_idx|    
      [:left, :right].each do |mode|
        longest_in_a_row = 0
        longest_in_a_row_pos = [0,0]
        in_a_row = 0
        if mode == :left
        start_row = 0 
        start_col = 0
        else 
           start_row = @map.size-1
           start_col =  @map[start_row].size-1
        end 

        while start_row < @map.size && start_col < @map[start_row].size && start_row >=0 && start_col >=0
          col = start_col
          row = start_row
          while  row < @map.size && col < @map[row].size && row >=0 && col >=0 && @map[row][col] == player_idx
            in_a_row = in_a_row+1
            if in_a_row > longest_in_a_row
              longest_in_a_row = in_a_row
              longest_in_a_row_pos = [row,col]
            end
            row = row+1 
            col = col+1
          end
          in_a_row = 0 
          if mode == :left 
            start_col = start_col+1 
            if start_col >= @map[start_row].size
              start_row = start_row+1
              start_col = 0
              in_a_row = 0
            end
          elsif mode == :right
            start_col = start_col-1 
            if start_col <= 0
              start_col = @map[start_row].size-1
              start_row = start_row-1
              in_a_row = 0
            end
          end
        end
        if longest_in_a_row >= @in_a_row
          puts "#{ longest_in_a_row } #{ mode } #{longest_in_a_row_pos }"
          return  player_idx
        end
      end
    end
    false
  end 

  def check_winner
    @players.size.times do |player_idx|    
      [:horizontal, :vertical].each do |mode|
        longest_in_a_row = 0
        longest_in_a_row_pos = [0,0]
        in_a_row = 0

        row = 0 
        col = 0
        while row < @map.size && col < @map[row].size
          if @map[row][col] == player_idx
            in_a_row = in_a_row+1
            if in_a_row > longest_in_a_row
              longest_in_a_row = in_a_row
              longest_in_a_row_pos = [row,col]
            end
          else 
            in_a_row = 0 
          end
          if mode == :horizontal 
            col = col+1 
            if col >= @map[row].size
              row = row+1
              col = 0
              in_a_row = 0
            end
          elsif mode == :vertical
            row = row+1 
            if row >= @map.size
              col = col+1
              row = 0
              in_a_row = 0
            end
          end
        end
        if longest_in_a_row >= @in_a_row
          puts "#{ longest_in_a_row } #{ mode } #{longest_in_a_row_pos }"
          return  player_idx
        end
      end
    end
    false # no winner  
    end 

    

  def run
    raise "Wrong number of  players #{ @players.size }" unless @players.size == 2
   # while @moves < 100
      gameloop
      reset
      @moves += 1
    # end

    # Draw one last time to update the
    draw
    if @players_score[0] == @players_score[1]
      puts "  Players tie in #{@moves} moves! #{ @players_score.join(':')} draws: #{@draws_reached}"
    elsif @players_score[0] > @players_score[1]
      puts "  Player 0 win in #{@moves} moves! #{ @players_score.join(':')} draws: #{@draws_reached}"
    else
      puts "  Player 1 win in #{@moves} moves! #{ @players_score.join(':')} draws: #{@draws_reached}"
    end

  end
  
  def draw 
    str = @map.collect do |row|
      row.collect do |el|
        case el 
          when -1 then " "
          when 0 then "o"
          when 1 then "x"
        else 
            "A"
        end
      end.join( " | ")
    end.join("\n")
    puts str
  end 




  def gameloop
    winner =nil 
    draw_reached = nil 
    puts "new round"
    while  !winner && !draw_reached
      get_input
      winner = check_winner
      winner = check_winner_diagonal unless winner
      draw_reached = check_draw_reached unless winner
      if @delay > 0
        draw
        sleep( @delay )
      end 
    end
    if winner  
      puts "winner #{ winner }"
      looser = winner == 1 ? 0 : 1
      @players_score[ winner ] = @players_score[ winner ]+2 
      @players_score[ looser ] = @players_score[ looser ]-2 
      draw 
      # sleep(3)
    end
    if draw_reached 
      puts "draw"
      draw
      # sleep(2)
      @players_score[ 0 ] = @players_score[ 0 ]+1
      @players_score[ 1 ] = @players_score[ 1 ]+1
      @draws_reached = @draws_reached+1 
    end
    @players.each do |player|
      player.inform_game_ended # let players know the result
    end 

  end


end 
    
  



