module Newral
  module Networks
    class Sigmoid < Perceptron

      def output
        value = calculate_value
        @last_output =  1/(1+Math.exp(value*-1))
      end 

      # if you want to know how this works
      # visit https://mattmazur.com/2015/03/17/a-step-by-step-backpropagation-example/
      def delta_rule( expected: nil )
        error_delta = []
        @weights.each_with_index do |weight,idx|
          input = calculate_input(  @inputs[ idx ] )
          error_delta << -(expected-output)*(output)*(1-output )*input
        end
        error_delta
      end
      

      # this just works for 1 hidden layer 
      # https://stats.stackexchange.com/questions/70168/back-propagation-in-neural-nets-with-2-hidden-layers
      # bias also not adjusted as biases are seen as constants
      def delta_rule_hidden( output: nil, expected: nil, weights_at_output_nodes: nil )
        error_delta = []
        @inputs.each do |input|
          d_e_total_d_out = 0
          output.each_with_index do |result,idx|
            d_e_total_d_out_idx = -( expected[idx]-result )
            d_e_out_d_net = (1-result)*result
            d_e_total_d_out_idx = d_e_total_d_out_idx*d_e_out_d_net*weights_at_output_nodes[idx]
            d_e_total_d_out = d_e_total_d_out+d_e_total_d_out_idx
          end
          d_out_d_net = (1-@last_output)*@last_output
          error_delta << d_e_total_d_out*d_out_d_net*calculate_input( input )
        end
        error_delta
      end 

      # depending on where the neuron is placed we need other infos to adjust the weights 
      # on output we just need the expected results
      # for hidden neurons we also need to know the weights at the output nodes 
      # and the actual output of the network
      def adjust_weights( expected: nil, learning_rate:0.5, layer: :output, weights_at_output_nodes: nil, output: nil )
        error_delta = layer.to_sym == :output ?  delta_rule( expected: expected ) : delta_rule_hidden( output: output, expected: expected, weights_at_output_nodes: weights_at_output_nodes )
        @weights.each_with_index do |weight,idx|
          @weights[idx] = @weights[idx]-error_delta[ idx ]*learning_rate
        end 
      end 

    end
  end

end