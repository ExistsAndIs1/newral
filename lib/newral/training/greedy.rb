module Newral
  module Training
    class Greedy
      attr_reader :best_function, :best_error, :input
      def initialize( input: [], output: [], iterations:10**5, klass: Newral::Functions::Polynomial, klass_args: {}, start_function: nil   )
        @input = input
        @output = output
        @iterations = iterations
        @klass = klass
        @klass_args = klass_args
        @best_function = start_function
      end


      def process( start_fresh: false )
        @best_function = case 
          when start_fresh then @klass.create_random( @klass_args ) 
          when  @best_function then @best_function
        else 
           @klass.create_random( @klass_args )
        end
        @best_error = @best_function.calculate_error( input: @input, output: @output )
        @iterations.times do |i|
          function = @best_function.dup.move_random # move random is easier to implement with different function types
          error = function.calculate_error( input: @input, output: @output )
          if error < @best_error
            @best_error = error 
            @best_function = function
          end 
        end 
        @best_function
      end
        
    end 
  end 
end  