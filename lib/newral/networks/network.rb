module Newral
  module Networks
    module Errors 
      class InvalidType < StandardError; end 
      class IdentifierExists < StandardError; end 
      class NotImplemented < StandardError; end 
    end 

    class Network
      attr_reader :output, :neurons, :layers

      def initialize
        @layers = {}
        @neurons = {}
        @layer_identifier = "input"
      end 

      def self.define( &block )
        layout = self.new 
        layout.instance_eval( &block )
        layout
      end 

      def add_layer( identifier, &block )
        @layer_identifier = identifier
        @layers[ identifier ] = Layer.new( identifier: identifier )
        self.instance_eval &block if block_given?
      end
      
      def add_neuron( identifier, neuron: nil, weights: nil, bias: nil, weight_length: nil, type: 'sigmoid' )
        raise Errors::IdentifierExists if @neurons[ identifier ] && (  neuron || weights || bias )
        unless neuron 
          neuron = case type.to_s 
            when 'perceptron' then Perceptron.new( weights: weights, bias: bias, weight_length: weight_length  )
            when 'sigmoid' then Sigmoid.new( weights: weights, bias: bias , weight_length: weight_length )
          else 
            raise Errors::InvalidType
          end 
        end 
            
        @neurons[ identifier ] = neuron
        @layers[ @layer_identifier ].add_neuron( neuron )
      end 

      # specify the identifiers of the two neurons to connect
      def connect( from: nil, to: nil )
        input_neuron = @neurons[ to ]
        output_neuron  = @neurons[ from ]
        input_neuron.add_input( output_neuron  )
      end

      def update_first_layer_with_vector( input )
        layer = @layers.first
        @output = layer[1].neurons.collect do |n|
          n.update_with_vector input
        end
        @output 
      end 
      
      def update_neuron( identifier, input  )
        @neurons[ identifier ].update_with_vector( input )
      end 

      def update_layers( start:0 )
        @layers.to_a[start..@layers.size].each do |layer |
          @output = layer[1].neurons.collect do |n|
              n.output
          end 
        end
      end 

      def update_with_vector( input )
        update_first_layer_with_vector( input )
        update_layers( start: 1)
        @output 
      end

      # use this for simple networks were neurons are set by hand
      def update( &block )
        self.instance_eval( &block ) if block_given?  
        update_layers
        @output
      end
      
      def output_of_neuron( identifier )
        @neurons[ identifier ].output
      end

      def train( inputs: [], output: [] )
        raise Errors::NotImplemented, "Use Subclass Backpropagation Training"
      end

      def set_weights_and_bias( layer: 'hidden', weights: [], bias: [])
        @layers[layer].neurons.each_with_index do |neuron,idx|
          neuron.set_weights_and_bias( weights: weights[ idx ], bias: bias[idx])
        end 
      end

      # by implementing these functions we can use a network for all 
      # training algorithms (although this is really just a proove of concept as using Greedy for Neural Networks does not lead to great results)

      def calculate( input )
        update_with_vector( input )
      end

      def calculate_error( input: [],output: [] )
        expected_values = [] # output can be longer than input
        calculated_values = []
        input.each_with_index do |x,idx|
          calculated_values << calculate( x )
          expected_values << output[idx] 
        end 
        Newral::ErrorCalculation.mean_square( calculated_values, expected_values  )/2
      end

      def number_of_directions
        @neurons.sum{ |n| n[1].number_of_directions }
      end

      def move( direction: 0, step:0.01, step_percentage: nil )
        raise Errors::InvalidDirection if direction >= number_of_directions
        new_network = Marshal.load(Marshal.dump(self))
        idx = 0
        new_network.neurons.each do |key,neuron|
          if idx+neuron.number_of_directions-1 >= direction # 
            meuron = neuron.dup.move( direction: direction-idx, step: step, step_percentage: step_percentage)
            return new_network 
          end 
          idx = idx+neuron.number_of_directions
        end
        new_network
      end 

      def move_random( low_range: -0.9, high_range: 0.9 ) 
        number_of_directions.times do |direction|
          step = low_range+rand()*(high_range.to_f-low_range.to_f) 
          move( direction: direction, step: step )
        end
        self
      end
          


    end 
  end 
end