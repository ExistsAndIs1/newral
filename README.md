# Newral

I recently started to learn about AI. 
Of course there are great libraries out there but I wanted to have something that makes it easy to test the different concepts to really understand them.
Also I wanted to have a playground to easily see how good different approaches work for different data sets.
I chose the name newral as its for newbies trying out neural networks and other AI related concepts

In the implementation I tried to write as little code as possible and used classes trying to avoid "array index hell".
So the data structures are in no way tuned for efficiency, rather I tried to make clear what actually is going on.
For every concept there should be at least one test to show it in action.

## Install

```ruby
gem install newral
```

## What it does
Everything is still quite early stages but there are a lot of things you can do already

* Training Functions 
  * Hill Climbing
  * Greedy
  * Gradient Descent 

* K-Means Clustering
* K-Nearest Neighbour

* Neural Networks 
  * Easily define simple ones often used in Tutorials
  * Backpropagation 

* Graphs 
  * Tree Search
  * Cheapest First
  * A Star 

* Q-Learning
Learn the computer to play Tic-Tac Toe (or other simple games )

I must say that this is really a total side project for me, so don´t expect lots of updates or bugfixes.
Whenever I thought about it there are links to the tutorials or websites I used (which will explain the theory much better than I ever could).
Please check out the tests where there are a few examples of possible use cases.

Stuff still in even earlier stages 
* everything in genetic folder
* bayes / probability 


So lets do some basic stuff

## Error Calculation

lets assume we have 3 calculated results by our function and 3 expected outputs 
```ruby
current =  [1,2,3]
expected = [2,4,6]

so what´s the error

Newral::ErrorCalculation.mean_square( current, expected  )
```

same thing for vectors 
```ruby
 current = [
        [1,2,3],
        [3,9,16]
        
      ]

      expected = [
        [2,4,6],
        [4,8,9]
      ]

Newral::ErrorCalculation.mean_square( current, expected  )
```

## Classifiers

```ruby
points = [
  [1,1],[2,2],[4,4],
  [10,9],[11,12],[13,7]
].shuffle

n= Newral::Classifier::KMeansCluster.new( points, cluster_labels:[:cows,:elefants] ).process
n.clusters[:elefants].points
n.clusters[:cows].points

n=Newral::Classifier::Dendogram.new( points ).process
n.to_s
```

## Neural Networks 

### create some neurons 

```ruby
perceptron = Newral::Networks::Perceptron.new(weights: [-2,-2],bias: 3) # look its a NAND gate
perceptron.update_with_vector [1,1]

sigmoid = Newral::Networks::Sigmoid.new(weights: [-2,-2],bias: 3) # sigmoids are much cooler 
sigmoid.update_with_vector [1,1]
```

### create a basic network 
```ruby
      network = Newral::Networks::Network.define do 
        add_layer "input" do 
          add_neuron 'a', weights: [-2,-2],bias: 3, type: 'perceptron'
          add_neuron 'b', weights: [-2,-2],bias: 3, type: 'perceptron'
        end 
        add_layer "output" do 
          add_neuron 'c', weights: [-2,-2],bias: 3, type: 'perceptron'
        end 

        connect from:'a', to:'c'
        connect from:'b', to:'c'
      end

      network.update_with_vector [1,1]
```

### create a network and perform backpropagation 
```ruby
inputs = [
        [0.05,0.1]
      ]
      outputs = [
        [0.01,0.99]
      ]
      network = Newral::Networks::BackpropagationNetwork.new( number_of_hidden: 2, number_of_outputs: 2)
      network.set_weights_and_bias( layer: 'hidden', weights:[[0.15,0.2],[0.25,0.3]],bias:[0.35,0.35])
      network.set_weights_and_bias( layer: 'output', weights:[[0.4,0.45],[0.5,0.55]], bias:[0.6,0.6])
      network.calculate_error( input: inputs, output: outputs ) # stupid network
      1000.times do 
        network.train input: inputs , output:outputs
      end 

      network.calculate_error( input: inputs, output: outputs ) # look it learned
```



## Load some data 

load the IRIS data set (Hello World of AI) located in test folder
```ruby
data = Newral::Data::Csv.new(file_name:File.expand_path('../test/fixtures/IRIS.csv',__FILE__))
data.process
cluster_set = Newral::Classifier::KMeansCluster.new( data.inputs, cluster_labels: data.output_hash.keys ).process
cluster_set.clusters.length # There are 3 different types 
```

```ruby
data = Newral::Data::Csv.new(file_name:File.expand_path('../test/fixtures/IRIS.csv',__FILE__))
data.process

network = Newral::Networks::BackpropagationNetwork.new( number_of_inputs: data.inputs.first.size, number_of_hidden: data.inputs.first.size, number_of_outputs: data.output_hash.keys.size )
network.calculate_error( input: data.inputs, output: data.output_as_vector ) # using a network with random weights  
100.times do
  network.train( input: data.inputs, output: data.output_as_vector ) # Hard training is the key to success in any neural nets life
end 
network.calculate_error( input: data.inputs, output: data.output_as_vector ) # hey it now knows flowers better than me!
```

Of course we don´t want oversampling so we should train and test on different data sets

```ruby
data = Newral::Data::Csv.new(file_name:File.expand_path('../test/fixtures/IRIS.csv',__FILE__))
data.process

network = Newral::Networks::BackpropagationNetwork.new( number_of_inputs: data.inputs.first.size, number_of_hidden: data.inputs.first.size, number_of_outputs: data.output_hash.keys.size )
network.calculate_error( input: data.sub_set(set: :inputs, category: :validation ), output: data.output_as_vector( category: :validation ) ) 

100.times do
  network.train( input: data.sub_set(set: :inputs, category: :training ), output: data.output_as_vector( category: :training ) ) 
end 

network.calculate_error( input: data.sub_set(set: :inputs, category: :validation ), output: data.output_as_vector( category: :validation ) ) 

```

here comes the heavy stuff for this little library, load the MNIST data set (60000 images with 28*28 pixels).
You can read more about MNIST http://yann.lecun.com/exdb/mnist/
```ruby
data = Newral::Data::Idx.new( file_name:'~/Downloads/train-images-idx3-ubyte', label_file_name:'~/Downloads/train-labels-idx1-ubyte')
data.process

sample_data = data.sample( limit:100 ) 
sample_data.downsample_input!( width:2,height:2,width_of_line:28 ) # create less resolution pictures

sample_data2 = data.sample( limit:100, offset:100  ) # a 2bd sample
sample_data2.downsample_input!( width:2,height:2,width_of_line:28 )


network = Newral::Networks::BackpropagationNetwork.new( number_of_inputs: sample_data.inputs.first.size, number_of_hidden: sample_data.inputs.first.size, number_of_outputs: sample_data.output_hash.keys.size )

# lets compare the error of a random network vs one trained one
network.calculate_error( input: sample_data2.inputs, output: sample_data2.output_as_vector )

# use first sample to train
network.train( input: sample_data.inputs, output: sample_data.output_as_vector )

# now calculate the error of untrained sample
# it should still go down
network.calculate_error( input: sample_data2.inputs, output: sample_data2.output_as_vector )

```


## use a tree Search to find the fastest path from Arad to Bucharest
```ruby
edges,nodes,node_locations = setup_bulgarian_map # find this in the test folder 
      g = Newral::Graphs::Graph.new 
      g.add_nodes nodes
      g.add_edges edges
      t=Newral::Graphs::CheapestFirst.new( graph: g, start_node: 'Arad', end_node:'Bucharest')
      path = t.run
      path.cost
```

## Use QLearning to play Tic Tac Toe

as we know good players will always reach a draw

```ruby
require './test/games/tic_tac_toe_game'

  game = TicTacToeGame.new  # ( width: 8, height: 6, in_a_row: 4 )
      player1 = Newral::QLearning::Base.new( game: game, id: 0 )
      player2 = Newral::QLearning::Base.new( game: game, id: 1 )
      # training
      1000.times do
        game.run
        game.reset
      end
      game.reset( reset_score: 1 )
      player1.set_epsilon 1 # stop doing random moves, we know the game
      player2.set_epsilon 1

   game.run # => its a draw  
```

## Use Training Algorithms to best approximate data with a function
Many typical functions suited for such approximations are already there
```ruby
f= Newral::Functions::Vector.new vector: [1,6], bias:1 
f.calculate [4,7] #  4*1+6*7+1 => 47
 

Newral::Functions::Polynomial.new factors: [2,5,1] 
f.calculate 2 # 2*(2**2)+5*2+1 => 19
```

first lets use a basic polynominal function 
```ruby
      input = [2,4,8]
      output = [4,16,64] # best function is x**2, lets see if our training algorithms find them
      g=Newral::Training::Greedy.new( input: input, output: output, klass: Newral::Functions::Polynomial )
      g.process 
      g.best_function.calculate_error( input: input, output: output )
            
      h=Newral::Training::HillClimbing.new( input: input, output: output, klass: Newral::Functions::Polynomial, start_function: g.best_function )
      h.process 
      h.best_function.calculate_error( input: input, output: output )
      
      # Gradient descent with error gradient approximation function 
      d=Newral::Training::GradientDescent.new( input: input, output: output, klass: Newral::Functions::Polynomial )
      d.process  
      d.best_function.calculate_error( input: input, output: output )
```

now lets use a Vector
```ruby

      input = [[1,2],[2,4]]
      output=[3,7]
      g=Newral::Training::GradientDescent.new( input: input, output: output, klass: Newral::Functions::Vector )
      g.process
      g.best_function.calculate_error( input: input, output: output )
  ```