# http://neuralnetworksanddeeplearning.com/chap1.html
module Newral
  module Networks
    module Errors
      class InputAndWeightSizeDiffer < StandardError; end 
      class WeightsAndWeightLengthGiven < StandardError; end 
    end

    class Perceptron
      attr_reader :weights,:bias, :last_output, :inputs
      # to create random weights just specify weight_length
      def initialize(weights:[],bias:0, weight_length: nil, max_random_weight:1, min_random_weight:-1 )
        raise Errors::WeightsAndWeightLengthGiven if weight_length && ( weights || ( weights && weights.size > 0 ))
        @max_random_weight = max_random_weight
        @min_random_weight=  min_random_weight
        @weights =weights || []
        @weights = weight_length.times.collect{ |i| (max_random_weight-min_random_weight)*rand()+min_random_weight } if weight_length
        @bias = bias || (weight_length && (max_random_weight-min_random_weight)*rand()+min_random_weight ) || 0
        @inputs = []
        @last_output = nil
      end 

      def set_weights_and_bias( weights:[], bias: nil )
        @weights = weights
        @bias = bias || 0 # if none specified
      end 

      def calculate_value 
        raise Errors::InputAndWeightSizeDiffer, "weights: #{@weights.size  }, #{ @inputs.size }" unless @weights.size == @inputs.size
        value = 0
        @inputs.each_with_index do |input,idx|
          val = calculate_input( input )
          value = value+val*@weights[idx]
        end
        value = value+@bias 
      end 

      def calculate_input( input )
        input.kind_of?( Perceptron ) ? input.last_output : input
      end

      def output
        @last_output = calculate_value <= 0 ? 0 : 1
      end

      def update_with_vector( inputs )
        @inputs = inputs
        output
      end

      def add_input( object )
        if object.kind_of?( Array ) 
           @inputs=object
        else 
          @inputs << object
        end
        # automatically add a weight if number of inputs exceeds weight size 
        weights << (@max_random_weight-@min_random_weight)*rand()+@min_random_weight if weights.length < @inputs.length
      end

      # move + number of directions are just needed for some training algorithms 
      # not typically used for neural networks (like greedy)
      # mainly implemented here for a proove of concept
      def number_of_directions
        @weights.size+1
      end
 

       def move( direction: 0, step:0.01, step_percentage: nil )
        raise Errors::InvalidDirection if direction >= number_of_directions
        if direction < @weights.size 
          @weights[direction] = step_percentage ?  @weights[direction]*(1+step_percentage.to_f/100) : @weights[direction]+step
        else
          @bias = step_percentage ?  @bias*(1+step_percentage.to_f/100) : @bias+step
        end
        self
      end 
      

    end

  end
end

