module Newral
  module Networks
    class Layer
      attr_reader  :neurons, :identifier

      def initialize( identifier: nil )
          @identifier = identifier
          @neurons = []
      end 
      
      def add_neuron( neuron )
        @neurons << neuron 
      end

      def weights 
        @neurons.collect(&:weights).flatten
      end 

      def biases 
        neurons.collect(&:bias)
      end

      def outputs
        neurons.collect(&:output)
      end
    end 
  end 
end 