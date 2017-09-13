module Newral
  module Training
    class GradientDescent
      attr_reader :best_function, :best_error, :input
      def initialize( input: [], output: [], iterations:10**5, klass: Newral::Functions::Polynomial, klass_args: {}, start_function: nil   )
        @input = input
        @output = output
        @iterations = iterations
        @klass = klass
        @klass_args = klass_args
        @best_function = start_function
      end


      def process( start_fresh: false, learning_rate:0.01, step:0.01 )
        @best_function = ( start_fresh ? @klass.create_random( @klass_args ) : @best_function || @klass.create_random( @klass_args )).dup
        @best_error = @best_function.calculate_error( input: @input, output: @output ) 
        optimized_error =  0
        @iterations.times do 
            function = @best_function.dup.move_with_gradient( input: @input, output: @output, learning_rate: learning_rate, step: step )
            optimized_error = function.calculate_error( input: @input, output: @output ) 
            if optimized_error >= @best_error 
              step = step/10 if step > 10**-8 # # slow down
              learning_rate = learning_rate / 10 if learning_rate > 10**-8
            else 
              @best_function = function
              best_error = optimized_error
            end 
        end 
        @best_error = @best_function.calculate_error( input: @input, output: @output )
        @best_function
      end
        
    end 
  end 
end  