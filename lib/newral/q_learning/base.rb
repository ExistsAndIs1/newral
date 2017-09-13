module Newral
  module QLearning
    class Base
      attr_accessor  :game
      # this q_learning algorithm was posted here
      # https://www.practicalai.io/teaching-ai-play-simple-game-using-q-learning/
      # however I extended it so it can play more games
      # also the q_table is implemente as a hash so actions can differ at different positions
      # this way the algorithm also needs to know less about the game
      def initialize( id: nil, game: nil, learning_rate: 0.4, discount: 0.9, epsilon: 0.9, sleep_time: 0.001 )
        game.set_player( self )
        @id = id 
        @game = game
        @learning_rate = learning_rate
        @discount = discount
        @epsilon = epsilon
        @sleep = sleep_time
        @random = Random.new
        @q_hash = {}
      end

      def set_epsilon( epsilon )
        @epsilon = epsilon
      end

      def inform_game_ended
        get_input( move: false )
      end


      def get_input( move: true )
        # Our new state is equal to the player position
        @outcome_state = @game.get_position( player: self )
        
        # which actions are available to the player at the moment?
        @actions = @game.get_actions( player: self )
        
        # is this the first run
        initial_run = @q_hash.empty? 

        @q_hash[@outcome_state] = @q_hash[@outcome_state] || {}
        @actions.each do |action| 
           @q_hash[@outcome_state][action] = @q_hash[@outcome_state][action] ||  0.1 # @random.rand/10.0
        end 

        if initial_run 
          @action_taken = @actions.first
        elsif @old_state
          # If this is not the first run
          # Evaluate what happened on last action and update Q table
          
          # Calculate reward
          reward = 0 # default is 0
          if @old_score < @game.get_score( player: self )
            reward =  [@game.get_score( player: self )-@old_score,1].max # reward is at least 1 if our score increased
          elsif @old_score > @game.get_score( player: self )
            reward =  [@old_score-@game.get_score( player: self ),-1].min # reward is smaller or equal -1 if our score decreased
          else 
            reward = -0.1 # time is money, we punish moves 
          end
           @q_hash[@old_state][@action_taken] = @q_hash[@old_state][@action_taken] + @learning_rate * (reward + @discount * (@q_hash[@outcome_state]).values.max.to_f - @q_hash[@old_state][@action_taken])
        end
 
        # Capture current state and score
        @old_score = @game.get_score( player: self )
        @old_state = @game.get_position( player: self ) # we remember this for next run, its current state 
        @old_actions = @actions
        if move # in the goal state we just update the q_hash
          
          # Chose action based on Q value estimates for state
          if @random.rand > @epsilon ||  @q_hash[@old_state].nil?
            # Select random action
            @action_taken_index = @random.rand(@actions.length).round
            @action_taken = @actions[@action_taken_index]
          else
            # Select based on Q table, remember @old_state is equal to current state at this point
            @action_taken = @q_hash[@old_state].to_a.sort{ |v1,v2| v2[1]<=>v1[1]}[0][0]
            raise "impossible action #{ @action_taken } #{@old_state} #{@q_hash[ @old_state ] } #{ @actions } #{@old_actions } " unless @actions.member?( @action_taken)
          end

          # Take action
          return @action_taken
        else 
          @old_state = nil # we do not have a old state any more as we have reached an end state
        end 
      end

    end
  end 
end