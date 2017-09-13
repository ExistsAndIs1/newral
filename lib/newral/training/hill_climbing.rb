module Newral
  module Training
    class HillClimbing
      attr_reader :best_function, :best_error, :input, :needed_iterations
      def initialize( input: [], output: [], iterations:10**5, klass: Newral::Functions::Polynomial, klass_args: {}, start_function: nil  )
        @input = input
        @output = output
        @iterations = iterations
        @klass = klass
        @klass_args = klass_args
        @best_function = start_function
        @needed_iterations = 0
      end


      def process( start_fresh: false, max_error:0.01 )
        @best_function = case 
          when start_fresh then @klass.create_random( @klass_args ) 
          when  @best_function then @best_function
        else 
           @klass.create_random( @klass_args )
        end
        
        function = @best_function.dup.move_random( @klass_args )
        @best_error = @best_function.calculate_error( input: @input, output: @output )
        number_of_directions = @best_function.number_of_directions
        step_sizes = [1]*number_of_directions
        acceleration = 1.2
        candidates = [
          -acceleration,
          -1/acceleration,
          0,
          1/acceleration,
          acceleration
        ]
        i=0 
        best_local_function = @best_function.dup
        before_error = 99999
        after_error = 1
        moved = true
        while i<@iterations  && @best_error > max_error 
          moved = false
          before_error = function.calculate_error( input: @input, output: @output )
          number_of_directions.times do |direction|
            best_candidate = -1
            best_candidate_error = 9999999
            candidates.each do |candidate| 
              temp_function = function.dup.move( direction: direction, step: step_sizes[ direction ]*candidate)
              error = temp_function.calculate_error( input: @input, output: @output )
              if error < best_candidate_error
                best_candidate = candidate
                best_candidate_error = error
                if error < @best_error
                  @best_error = best_candidate_error
                  @best_function = temp_function.dup
                end
              end 
            end
            if best_candidate == 0
              step_sizes[direction] = step_sizes[direction] / acceleration # take it slower
            else
              moved = true
              function.move( direction: direction, step: step_sizes[ direction ]*best_candidate )
              # puts "moving #{direction} by #{(step_sizes[ direction ]*candidates[best_candidate]).to_s}"
              step_sizes[direction] = step_sizes[ direction ] * best_candidate # accelerate
            end
          end
          after_error = function.calculate_error( input: @input, output: @output )
          i=i+1
        end
        @needed_iterations = i 
        @best_function
      end
        
    end 
  end 
end  