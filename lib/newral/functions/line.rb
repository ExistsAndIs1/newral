module  Newral
  module Functions
   

    class Line < Base
      attr_accessor :center
     
      def initialize( factor: 1, bias: 0, center: nil )
        @factor = factor
        @bias = bias
        @center = center.dup if center
      end 

      def calculate( input ) 
        @factor*input+@bias
      end

      def self.create_random( low_range: -9, high_range: 9 )
        factor= low_range+rand(high_range-low_range)
        bias = low_range+rand(high_range-low_range)
        self.new( factor: factor, bias: bias )
      end

       def number_of_directions
        2 
      end 

      def move( direction: 0, step:0.01, step_percentage: nil )
        case direction
          when 0 then @bias=(step_percentage ? @bias*(1+step_percentage.to_f/100) : @bias+step )
          when 1 then @factor=(step_percentage ? @factor*(1+step_percentage.to_f/100)  : @factor+step )
        else 
          raise Errors::InvalidDirection
        end
        self
      end

      def move_with_gradient( input:[], output:[], learning_rate: 0.01 )
         bias_gradient = 0
         factor_gradient = 0
         input.each_with_index do |x,idx|
           bias_gradient = bias_gradient-2.0/input.size*( output[idx]-( @factor*x + @bias ))
           factor_gradient = factor_gradient-2.0/input.size*x*( output[idx]-(@factor*x+@bias) )
           # b_gradient += -(2/N) * (points[i].y - ((m_current*points[i].x) + b_current))
            # m_gradient += -(2/N) * points[i].x * (points[i].y - ((m_current * points[i].x) + b_current))
          end 
        @bias = @bias - (learning_rate * bias_gradient)
        @factor = @factor - (learning_rate * factor_gradient)
      end
    end 
  end 
end