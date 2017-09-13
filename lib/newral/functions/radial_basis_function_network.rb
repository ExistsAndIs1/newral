module Newral 
 module Functions
  class RadialBasisFunctionNetwork < Base
    attr_reader :weights, :functions
    def initialize( centers:[], weights: [], bias_weight: 1, klass: Newral::Functions::Gaussian )
      @klass = klass 
      @weights = weights.dup
      @centers = centers.dup
      @functions = []
      @weights.each_with_index do |weight,idx|
        @functions << klass.new( center:centers[idx], factor: weight )
      end
      @functions << Line.new(factor:0,bias: bias_weight) if bias_weight != 0
    end

    def calculate( input )
      result = 0
      @functions.each do |function|
        result = result + function.calculate( input )
      end
      result.to_f
    end


     def self.create_random(  length: 3, low_range: -9, high_range: 9, klass: Newral::Functions::Gaussian  )
        weights = []
        centers = []
        length.times do 
          weights << low_range+rand(high_range-low_range)
          centers << [low_range+rand(high_range-low_range)]
        end
        self.new( centers:centers, weights: weights, bias_weight: low_range+rand(high_range-low_range), klass: klass  )
     end

     def number_of_directions
       @weights.size+@centers.collect{ |c| c.size }.sum
     end

      def move( direction: 0, step:0.01, step_percentage: nil )
        raise Errors::InvalidDirection if direction >= number_of_directions
        if direction < @weights.size 
          @weights = @weights.dup
          @weights[direction] = step_percentage ? @weights[direction]*(1+step_percentage.to_f/100) : @weights[direction]+step
        else
          mod = @centers.first.size 
          @centers = @centers.dup
          @centers[(direction-@weights.size)/mod][(direction-@weights.size)%mod] = step_percentage ? @centers[(direction-@weights.size)/mod][(direction-@weights.size)%mod]*(1+step_percentage.to_f/100) : @centers[(direction-@weights.size)/mod][(direction-@weights.size)%mod]+step
        end 
        self
      end

    end
  end
end