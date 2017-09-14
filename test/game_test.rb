
require 'test_helper'
require 'games/cheese_game'
require 'games/cheese_game2d'
require 'games/tic_tac_toe_game'
include Newral
class GameTest < Minitest::Test
    # a NAND operator 
    # most simple Neural Net ever
    def test_simple_cheese
      game = CheeseGame.new 
      Newral::QLearning::Base.new( game: game )
      # training
      100.times do
        game.run
        game.reset
      end

      #playing
      total_score = 0
      total_moves = 0
      10.times do 
        game.run
        total_moves = total_moves+game.moves 
        total_score = total_score+game.get_score
        game.reset
      end

      assert_equal total_score , 50 # we always win
      assert total_moves/10 < 45 
    end

    def test_cheese_2d
      game = CheeseGame2d.new 
      Newral::QLearning::Base.new( game: game )
      # training
      100.times do
        game.run
        game.reset
      end

      #playing
      total_score = 0
      total_moves = 0
      game.delay = 0
      10.times do 
        game.run
        total_moves = total_moves+game.moves 
        total_score = total_score+game.get_score
        game.reset
      end

      assert_equal total_score , 50 # we always win
      # assert total_moves/10 < 45 
    end

    def test_tic_tac
      game = TicTacToeGame.new  # ( width: 8, height: 6, in_a_row: 4 )
      #   game.delay=2
      player1 = Newral::QLearning::Base.new( game: game, id: 0 )
      player2 = Newral::QLearning::Base.new( game: game, id: 1 )
      # training
      1000.times do
        game.run
        game.reset
      end
      game.reset( reset_score: 1 )
      player1.set_epsilon 1
      player2.set_epsilon 1
      # game.delay=2
      100.times do
        game.run
        game.reset
      end

    end
end

