
require 'test_helper'
include Newral
class BaseTest < Minitest::Test
    # a NAND operator 
    # most simple Neural Net ever
    def test_nand
      s=Newral::Networks::Perceptron.new(weights: [-2,-2],bias: 3)
      assert_equal s.update_with_vector([0,0]),1
      assert_equal s.update_with_vector([0,1]),1
      assert_equal s.update_with_vector([1,0]),1
      assert_equal s.update_with_vector([1,1]),0

      s=Newral::Networks::Sigmoid.new(weights: [-2,-2],bias: 3)
      assert_equal s.update_with_vector([0,0]).round.to_i,1
      assert_equal s.update_with_vector([1,1]).round.to_i,0
    end

    def test_size_mismatch
        s=Newral::Networks::Perceptron.new(weights: [-2,-2],bias: 3)
        assert_raises do
           # input vector is too big
           s.update_with_vector([0,0,0])
        end
         assert_raises do
           # input vector is too small
           s.update_with_vector([0])
        end
    end

    def test_simple_network 
      network = Newral::Networks::Network.define do 
        add_layer "input" do 
          add_neuron 'a', weights: [-2,-2],bias: 3, type: 'perceptron'
          add_neuron 'b', weights: [-2,-2],bias: 3, type: 'perceptron'
        end 
      end
      assert_equal network.layers["input"].weights, [-2,-2,-2,-2]
      assert_equal network.layers["input"].biases, [3,3]

      assert_equal network.update_with_vector([0,0]),[1,1] # 2 nands
      assert_equal network.layers["input"].outputs, [1,1] # as we have just 1 layer its the same

      assert_equal network.update_with_vector([0,1]),[1,1] # 2 nands
      assert_equal network.update_with_vector([1,0]),[1,1] # 2 nands
      assert_equal network.update_with_vector([1,1]),[0,0] # 2 nands
    end 

    def test_random_network 
      network = Newral::Networks::Network.define do 
        add_layer "input" do 
          4.times do |i|
            add_neuron "random_#{ i }", weight_length: 3, type: 'perceptron'
          end
        end 
      end
      assert_equal network.neurons.size, 4
      assert network.update_with_vector [1,2,3]
    end 

    # http://neuralnetworksanddeeplearning.com/chap1.html
    def test_calculator_network
      network = Newral::Networks::Network.define do 
        add_layer "input" do 
          add_neuron 'input_a', weights: [1],bias: 0, type: 'perceptron'
          add_neuron 'input_b', weights: [1],bias: 0, type: 'perceptron'
        end 
        
        add_layer "level1" do 
          add_neuron 'nand1', weights: [-2,-2],bias: 3, type: 'perceptron'
        end 

        add_layer "level2" do 
          add_neuron 'nand2', weights: [-2,-2],bias: 3, type: 'perceptron'
          add_neuron 'nand3', weights: [-2,-2],bias: 3, type: 'perceptron'
        end 

        add_layer "output" do 
          add_neuron 'sum', weights: [-2,-2],bias: 3, type: 'perceptron'
          add_neuron 'carry', weights: [-4],bias: 3, type: 'perceptron'
        end 

        connect from: 'input_a', to: 'nand1'
        connect from: 'input_b', to: 'nand1'

        connect from: 'input_a', to: 'nand2'
        connect from: 'nand1', to: 'nand2'

        connect from: 'input_b', to: 'nand3'
        connect from: 'nand1', to: 'nand3'
        
        connect from: 'nand2', to: 'sum'
        connect from: 'nand3', to: 'sum'

        connect from: 'nand1', to: 'carry'
        
      end

      assert_equal network.update{
        update_neuron "input_a", [1]
        update_neuron "input_b", [1]
        
      }, [0,1]


      network.update{
        update_neuron "input_a", [0]
        update_neuron "input_b", [1]
        
      }
      assert_equal network.output_of_neuron("input_a"), 0
      assert_equal network.output_of_neuron("input_b"), 1
      assert_equal network.output_of_neuron("nand1"), 1
      assert_equal network.output_of_neuron("carry"), 0
      assert_equal network.output_of_neuron("sum"),1

      assert_equal network.update{
        update_neuron "input_a", [0]
        update_neuron "input_b", [0]
        
      }, [0,0]
      
      assert_equal network.update{
        update_neuron "input_a", [1]
        update_neuron "input_b", [0]
        
      }, [1,0]
    end
    
    # this is more a proove of concept, often we do not get lucky
    def test_training
      input = [[0,0],[1,0],[0,1],[1,1]]
      output = [1,1,1,0]
      network = Newral::Networks::Network.define do 
        add_layer "input" do 
          add_neuron 'a', weight_length: 2, type: 'perceptron'
        end 
      end
      g=Newral::Training::Greedy.new( input: input, output: output, start_function: network, iterations: 100 )
      g.process( start_fresh: false )
      assert g.best_function.calculate_error( input: input, output: output ) < 1, "best error too high: #{ g.best_error }" 
    end

    # https://mattmazur.com/2015/03/17/a-step-by-step-backpropagation-example/

    # hidden layer backpropagation
          # 
        # 0.7548067435409049 vs 0.01
        # 0.7769055198526518 vs 0.99
        # x1 = -(0.01-0.7548067435409049 )= 0.7448067435409049
        # x2=(1-0.7548067435409049)*0.7548067435409049 = 0.1850735234460795
        # y = x1*x2*0.4 = 0.05513760332540631

        # x1 = -(0.99-0.7769055198526518)
        # x2 = (1-0.7769055198526518)*0.7769055198526518
        # y = x1*x2*0.5 =  -0.01846712277952554

        # sum = -0.01846712277952554+0.05513760332540631
        # output of neuron =  0.6094497836283251
        # adjust (-0.01846712277952554+0.05513760332540631)*(1-0.6094497836283251)*0.6094497836283251*0.05

        #all_weights.each do
        #  sum_of 
        #  x1 = -(expected-actual)
        #  x2 = (1-actual)*actual
        #  y = x1*x2*weight_of_input_it_leads_to
        #  z = z+y
        # end of sum 

        #  adjust_weight_by z*(output)*(1-output)*input_for_weight
        
    def test_tutorial
      network = Newral::Networks::Network.define do 
        add_layer "hidden" do 
          add_neuron 'h1', weights:[0.15,0.2], bias:0.35, type: 'sigmoid'
          add_neuron 'h2', weights:[0.25,0.3], bias:0.35, type: 'sigmoid'
        end 

        add_layer "output" do 
          add_neuron 'o1', weights:[0.4,0.45], bias:0.6, type: 'sigmoid'
          add_neuron 'o2', weights:[0.5,0.55], bias:0.6, type: 'sigmoid'
        end 

        connect from: "h1", to:"o1"
        connect from: "h2", to:"o1"

        connect from: "h1", to:"o2"
        connect from: "h2", to:"o2"
      end

      network.calculate_error input:[[0.5,0.1]],output:[[0.01,0.99]]
      n=network.neurons["h1"]
      n.delta_rule_hidden output:[0.7548067435409049,0.7769055198526518], expected:[0.01,0.99],weights_at_output_nodes: [0.4,0.5]

      n=network.neurons["o1"]
      n.adjust_weights expected: 0.01
      
    end

    def test_tutorial_backpropagation
      inputs = [
        [0.05,0.1]
      ]
      outputs = [
        [0.01,0.99]
      ]
      network = Newral::Networks::BackpropagationNetwork.new( number_of_inputs: 2, number_of_hidden: 2, number_of_outputs: 2)
      network.set_weights_and_bias( layer: 'hidden', weights:[[0.15,0.2],[0.25,0.3]],bias:[0.35,0.35])
      network.set_weights_and_bias( layer: 'output', weights:[[0.4,0.45],[0.5,0.55]], bias:[0.6,0.6])

      assert_equal network.output_weights( network.neurons["hidden_0"] ), [0.4,0.5]
      assert_equal network.output_weights( network.neurons["hidden_1"] ), [0.45,0.55]

      assert_approximate network.update_with_vector(  inputs.first ), [0.7513, 0.772], allowed_error:0.001
      assert_approximate network.layers["hidden"].outputs, [0.5932699921071872, 0.596884378259767], allowed_error:0.001
     
      assert_approximate network.layers["output"].neurons[ 0 ].delta_rule(  expected:0.01 ), [0.0821, 0.08266762784753325], allowed_error:0.001
      assert_approximate network.layers["output"].neurons[ 0 ].adjust_weights( expected: 0.01 ),[0.3589,0.408], allowed_error:0.001
      
      # in the example he calculates with the original output weights so we have to reset them
      network.set_weights_and_bias( layer: 'hidden', weights:[[0.15,0.2],[0.25,0.3]],bias:[0.35,0.35])
      network.set_weights_and_bias( layer: 'output', weights:[[0.4,0.45],[0.5,0.55]], bias:[0.6,0.6])

      assert_approximate output=network.update_with_vector(  inputs.first ), [0.7513, 0.772], allowed_error:0.001

      assert_approximate network.layers["hidden"].neurons[ 0 ].delta_rule_hidden( expected: [0.01,0.99],  weights_at_output_nodes: [0.4,0.5], output: output ),[0.000438,0.000877], allowed_error:0.0001
      assert_approximate network.layers["hidden"].neurons[ 0 ].adjust_weights( layer: :hidden, expected: [0.01,0.99],  weights_at_output_nodes: [0.4,0.5], output: output ),[0.1497,0.199], allowed_error:0.001
      
      10000.times do 
        network.train input: inputs , output:outputs
      end 

      assert network.calculate_error( input: inputs, output: outputs ) < 0.001, "error too high: #{ network.calculate_error( input: inputs, output: outputs ) }"
    end
end

