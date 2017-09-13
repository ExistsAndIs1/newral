
require 'test_helper'
include Newral
class ErrorCalculationTest < Minitest::Test

    def test_sum_of_squares
      current =  [1,2,3]#
      expected = [2,4,6]
      sum_of_squares = (1-2)**2+(2-4)**2+(3-6)**2
      assert_equal Newral::ErrorCalculation.sum_of_squares( current, expected  ), sum_of_squares

      current = [
        [1,2,3],
        [3,9,16]
        
      ]

      expected = [
        [2,4,6],
        [4,8,9]
      ]
      sum_of_squares_row1 = (1-2)**2+(2-4)**2+(3-6)**2
      sum_of_squares_row2 = (3-4)**2+(9-8)**2+(16-9)**2
      assert_equal Newral::ErrorCalculation.sum_of_squares( current, expected  ), sum_of_squares_row1+sum_of_squares_row2
    end 

    def test_mean_square 
      current =  [1,2,3]#
      expected = [2,4,6]
      sum_of_squares = (1-2)**2+(2-4)**2+(3-6)**2
      assert_equal Newral::ErrorCalculation.mean_square( current, expected  ), sum_of_squares.to_f/3
    end 

    def test_root_mean_square 
      current =  [1,2,3]#
      expected = [2,4,6]
      sum_of_squares = (1-2)**2+(2-4)**2+(3-6)**2
      assert_equal Newral::ErrorCalculation.root_mean_square( current, expected  ), (sum_of_squares.to_f/3)**0.5
    end 
end 