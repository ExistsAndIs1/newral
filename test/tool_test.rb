
require 'test_helper'
include Newral
class ToolTest < Minitest::Test
    # small tests for our most basic functions
    def test_euclidean
      # a square + b square = c square
      assert_equal 2**2+2**2, (Newral::Tools.euclidian_distance( [0,2],[2,0])**2).to_i
    end

    def test_max
      assert_equal 3, (Newral::Tools.max_distance( [0,2],[2,5]))
    end 

    def test_taxi_cab
      assert_equal 3, (Newral::Tools.max_distance( [0,2],[2,5]))
    end 

    def test_k_nearest_neighbour
      point = [5,5]
      point2 = [41,41]
      cluster = {
        red: [[3,3],[4,4],[5,6],[7,7]],
        green: [[30,30],[40,40],[50,60],[70,70]],
      }

      neighbours = Newral::Tools.k_nearest_neighbour( point, cluster )
      puts neighbours.length
      assert_equal neighbours.first[0], :red
      assert_equal neighbours[1][0], :red

      neighbours = Newral::Tools.k_nearest_neighbour( point2, cluster )
      puts neighbours.length
      assert_equal neighbours.first[0], :green
      assert_equal neighbours[1][0], :green
    end

    def test_more_general_than_or_equal
      assert_equal Newral::Tools.more_general_than_or_equal( [[1,0,1],[0,0,1]] ), [0,-1,1]
    end

    def test_general_to_specific
      assert_equal Newral::Tools.general_to_specific( [[1,0,1],[0,0,1]] ), [-1,1,-1]
    end


end

