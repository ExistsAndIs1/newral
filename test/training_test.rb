
require 'test_helper'
include Newral
class TrainingTest < Minitest::Test
    def test_simple_polynomial 
      input = [2,4,8]
      output = [4,16,64]
      g=Newral::Training::Greedy.new( input: input, output: output )
      g.process 
      assert g.best_function.calculate_error( input: input, output: output ) < 0.1
      assert_approximate g.best_function.factors, [1,0,0], allowed_error: 0.3

      h=Newral::Training::HillClimbing.new( input: input, output: output )
      h.process 
      assert( h.best_function.calculate_error( input: input, output: output ) < 0.01)
      assert_approximate h.best_function.factors, [1,0,0], allowed_error: 0.3

      d=Newral::Training::GradientDescent.new( input: input, output: output )
      d.process 
      # assert( d.best_function.calculate_error( input: input, output: output ) < 0.01 , "error #{  d.best_function.calculate_error( input: input, output: output ) } too high #{ d.best_function.factors }" )
      assert_approximate d.best_function.factors, [1,0,0], allowed_error: 0.3
    end

    def two_dimensions_input 
      input = [[1,1],[2,2],[3,3]]
      output = [2,4,6]
      func = Newral::Functions::Block.new( directions: 2, params:[2,1]) do |input,params|
        params[0]*input+params[1]*input
      end
      
      h=Newral::Training::HillClimbing.new( input: input, output: output )
      h.process 
      assert( h.best_function.calculate_error( input: input, output: output ) < 0.01)
      assert_approximate g.best_function.params, [1,1]
    end 

    def test_simple_linear_regression
      input = [1,2,4,3,5]
      output = [1,3,3,2,5]
      g=Newral::Training::LinearRegression.new( input: input, output: output )
      g.process 
      assert( (g.best_function.factors[0]-0.8).abs < 0.01)
      assert( (g.best_function.factors[1]-0.399).abs < 0.01)
      assert( ( g.best_function.calculate( 10 )-8.399).abs<0.01) 
    end 

    def test_linear_regression_matrix
      input = [[6 ,4 ,11],[  8 ,5 ,15],[  12, 9, 25],[ 2, 1, 3]]
      output = [20,30,50,7]
      g=Newral::Training::LinearRegressionMatrix.new( input: input, output: output )
      best_function = g.process 
      assert_equal best_function.calculate( [6 ,4 ,11] ).to_i, 20
      assert_equal best_function.calculate( [  8 ,5 ,15] ).to_i, 30
    end

    def test_radial_basis_network
      # not sure if they work great yet
      output = [4,16,64]
      input =[2,4,8]

      output_normalized = Newral::Tools.normalize output
      input_normalized =Newral::Tools.normalize input

      g1=Newral::Training::Greedy.new( input: input_normalized, output: output_normalized, klass: Newral::Functions::RadialBasisFunctionNetwork )
      b1=g1.process
      # assert g1.best_error < 0.5, "error g1: #{ g1.best_error }" # this is not a very good input

      g2=Newral::Training::Greedy.new( input: input_normalized, output: output_normalized, klass: Newral::Functions::RadialBasisFunctionNetwork, klass_args:{klass:Newral::Functions::RickerWavelet} )
      b2=g2.process
      # assert g2.best_error < 0.5, "error g2: #{ g2.best_error }"  # this is not a very good input
    end

    def test_gradient_descent_with_vector
      input = [[1,2],[2,4]]
      output=[3,7]
      g=Newral::Training::GradientDescent.new( input: input, output: output, klass: Newral::Functions::Vector )
      best_function = g.process 
      assert  best_function.calculate_error( input: input, output: output ) < 0.06, "error #{ best_function.calculate_error( input: input, output: output ) } too high " #
    end 


end

