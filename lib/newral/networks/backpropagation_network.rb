module Newral
  module Networks
    module Errors
      class Errors::OnlyPossibleForHidden < StandardError ; end 
    end 

    class BackpropagationNetwork < Network
      def initialize( number_of_inputs:2, number_of_hidden:2, number_of_outputs:2 )
        super()
        add_layer "hidden" do 
          number_of_hidden.times do |idx|
            add_neuron "hidden_#{idx}", weight_length:number_of_inputs
          end 
        end
      
        
        add_layer "output" do 
          number_of_outputs.times do |idx|
            add_neuron "output_#{idx}", weight_length:number_of_hidden
          end 
        end
        
        # in this network all hidden neurons link to all output neurons
        @layers["hidden"].neurons.each do |hidden_neuron|
          @layers["output"].neurons.each  do |output_neuron|
            output_neuron.add_input hidden_neuron
          end 
        end
      end
  

      
      # gets an array of inputs and the corresponding expected outputs
      # first we update our output layer then our hidden layer
      def train( input: [], output: [] )
        before_error =  calculate_error( input: input,output: output )
        input.each_with_index do |input,idx| 
          calculated_output = update_with_vector( input )
          @layers["output"].neurons.each_with_index do |neuron,neuron_idx|
            neuron.adjust_weights( expected: output[ idx ][ neuron_idx ])
          end 

          @layers["hidden"].neurons.each do |neuron|
            neuron.adjust_weights( expected: output[ idx ], layer: :hidden, output: calculated_output, weights_at_output_nodes: output_weights( neuron ))
          end 
        end
        new_error =  calculate_error( input: input,output: output )
        before_error-new_error
      end 

      # gets the weights of the output neurons this input feeds to 
      # this of course can be done much simpler (as its always the nth weight of the output neuron)
      # however we want to stay explicit 
      def output_weights( neuron )
        raise Errors::OnlyPossibleForHidden unless @layers["hidden"].neurons.member?( neuron )
        weights = []
        @layers["output"].neurons.each do |output_neuron|
          output_neuron.inputs.each_with_index do |input,idx| 
            weights << output_neuron.weights[ idx ] if input == neuron
          end 
        end 
       weights 
      end 
      
    end 
  
  end
end 