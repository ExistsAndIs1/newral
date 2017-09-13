module  Newral
  module Functions
    class Gaussian < Base
      attr_reader :factors
      def initialize(  center:[0], factor:1 )
        @factor = factor
        @center = center.dup
      end 

      def calculate( input ) 
       calculate_for_center_distance( [input])
      end

      def calculate_for_center_distance( vector1  ) 
        distance = Newral::Tools.euclidian_distance( vector1, @center )
        Math.exp(-distance**2)*@factor
      end

     def self.create_random(  low_range: -9, high_range: 9 )
       self.new center:[low_range+rand(high_range-low_range)],factor: low_range+rand(high_range-low_range)
     end

     def number_of_directions
       1+@center.size
     end

     def move( direction: 0, step:0.01, step_percentage: nil )
        raise Errors::InvalidDirection if direction >= number_of_directions
        if direction == 0
          @factor = ( step_percentage ? @factor*(1+step_percentage/100) : @factor+step_percentage )
        else 
          @center = @center.dup
          @center[direction-1] =  step_percentage ?  @center[direction-1]*(1+step_percentage/100) : @center[direction-1]+step
        end
        self
      end 

    
    end
  end
end