module  Newral
  module Functions
  

    class Vector < Base
      attr_accessor :weights, :bias
      def initialize( vector: [1,1], bias: 0 )
        @vector = vector
        @bias = bias
      end 

      def calculate( input ) 
        @vector.zip( input ).map{|x, y| x * y}.sum  + @bias
      end

      def self.create_random(  length: 2, low_range: -9, high_range: 9 )
        vector = []
        length.times do 
          vector << low_range+rand(high_range-low_range)
        end
        self.new( vector: vector, bias: low_range+rand(high_range-low_range) )
     end

      def number_of_directions
        @vector.size+1
      end

       def move( direction: 0, step:0.01, step_percentage: nil )
        raise Errors::InvalidDirection if direction >= number_of_directions
        if direction < @vector.size 
          @vector[direction] = step_percentage ?  @vector[direction]*(1+step_percentage.to_f/100) : @vector[direction]+step
        else
          @bias = step_percentage ?  @bias*(1+step_percentage.to_f/100) : @bias+step
        end
        self
      end 
      
      # step argument is ignored here 
      def move_with_gradient( input:[], output:[], learning_rate: 0.01, step: nil )
         bias_gradient = 0
         vector_gradient = [0]*@vector.length
         input.each_with_index do |input_vector,idx|
           bias_gradient = bias_gradient-2.0/input.size*( output[idx]-(  @vector.zip( input_vector ).map{|x, y| x * y}.sum + @bias ))
           vector_gradient.each_with_index do |v,idx_2|
              vector_gradient[idx_2]=v-2.0/input.size*input_vector[idx_2]*( output[idx]-( @vector.zip( input_vector ).map{|x, y| x * y}.sum+@bias) )
           end
         end 
        @bias = @bias - (learning_rate * bias_gradient)
        new_vector = []
        @vector.each_with_index do |value,idx| 
          new_vector << value - (learning_rate * vector_gradient[idx])
        end 
        @vector = new_vector
        self
      end

    end
  end
end