module  Newral
  module Functions
    module Errors
      class InvalidDirection < ::StandardError; end 
      class NotImplemented < ::StandardError; end 
    end 

    class Base
      attr_accessor :center
     
      def calculate
        raise NotImplemented
      end 
      
      # approximates the descent calculation at a certain point
      def calculate_descent( input, difference: nil )
        difference = (input/10000.0).abs unless difference
       (calculate( input+difference )- calculate( input ))/difference
      end

      # finds the (local) minimum descent of a function
      def find_minimum( start_input, max_iterations: 1000, treshold: 10**-9 , learning_rate: 0.01 )
        descent = calculate_descent( start_input )
        iterations = 0
        input = start_input
        while descent.abs >  treshold && iterations < max_iterations
          old_input = input
          input = input-descent.to_f*learning_rate
          new_descent = calculate_descent( input )
          learning_rate = learning_rate.to_f/10   if new_descent*descent < 0  # slow down if descent changes
          descent = new_descent
          iterations = iterations+1
        end 
        { input: input, descent: descent, learning_rate: learning_rate, output: calculate( input ), iterations: iterations }
      end

      def calculate_for_center_distance( vector1  ) 
        calculate Newral::Tools.euclidian_distance( vector1, @center )
      end

      # if a function implements calculate,move+number_of_directions we can use it for 
      # all training algorithms (like hill climbing)
      # as shown in the Networks / network you do not need to derive from base function

      def self.create_random( low_range: -9, high_range: 9 )
        raise Errors::NotImplemented         
      end

      def number_of_directions
        raise Errors::NotImplemented 
      end 

   
      def move( direction: 0, step:0.01, step_percentage: nil )
        raise Errors::NotImplemented 
      end

      def move_several( directions:[], step:0.01, step_percentage: nil )
        directions.each do |direction| 
          move( direction: direction, step: step, step_percentage: step_percentage)
        end
        self
      end 

      # moves all directions randomly
      def move_random( low_range: -0.9, high_range: 0.9 ) 
        number_of_directions.times do |direction|
          step = low_range+rand()*(high_range.to_f-low_range.to_f) 
          move( direction: direction, step: step )
        end
        self
      end

      def calculate_error( input: [],output: [] )
        expected_values = [] # output can be longer than input
        calculated_values = []
        input.each_with_index do |x,idx|
          calculated_values << calculate( x )
          expected_values << output[idx] 
        end 
        Newral::ErrorCalculation.root_mean_square( calculated_values, expected_values  )
      end

      def error_gradient_approximation( direction: nil,  step: 0.01, input: nil, output: nil )
        current_error = calculate_error( input: input, output: output)
        new_pos = self.dup.move( direction: direction, step: step )
        new_error = new_pos.calculate_error( input: input, output: output)
        (new_error-current_error)/step
      end 

      # for  general functions we can only estimate the gradient of the error
      # by taking small steps
      def move_with_gradient( input:[], output:[], learning_rate: 0.01, step: 0.01 )
         number_of_directions.times do |direction|
          error_gradient = error_gradient_approximation( direction: direction, step: step, input: input, output: output )
          move( direction: direction, step:(-error_gradient*learning_rate))
        end
        self 
      end
    end
  end
end