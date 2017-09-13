module  Newral
  module Functions
    class Polynomial < Base
      attr_reader :factors
      def initialize(  factors:nil )
        @factors = factors.dup || [1]
        @length = @factors.size
      end 

      def calculate( input ) 
        result = 0
        @factors.each_with_index do |factor, idx|
          result = result+input**(@length-idx-1)*factor # this way its more readable 
        end 
        result
      end

      # caluates descent at input
      def calculate_descent( input )
        descent = 0
        @factors.each_with_index do |factor, idx|
          descent = descent+input**(@length-idx-2)*factor*(@length-idx-1) if @length-idx-2>= 0 # this way its more readable 
        end 
        descent
      end

     def self.create_random(  length: 3, low_range: -9, high_range: 9 )
        factors = []
        length.times do 
          factors << low_range+rand(high_range-low_range)
        end
        self.new( factors: factors )
     end

     def number_of_directions
       @factors.size 
     end 

      def move( direction: 0, step:0.01, step_percentage: nil )
        raise Errors::InvalidDirection if direction >= number_of_directions
        @factors = @factors.dup
        @factors[direction] = step_percentage ?  @factors[direction]*(1+step_percentage.to_f/100) : @factors[direction]+step
        self
      end 

    end
  end
end