module Newral
  require "matrix"
  require "nmatrix"
  require "newral/tools"

  require "newral/data/base"
  require "newral/data/csv"
  require "newral/data/idx"
  require "newral/data/cluster"
  require "newral/data/cluster_set"

  require "newral/error_calculation"

  require "newral/networks/perceptron"
  require "newral/networks/sigmoid"
  require "newral/networks/layer"
  require "newral/networks/network"
  require "newral/networks/backpropagation_network"

#  require "newral/probability" 
  require "newral/probability_set"
#  require "newral/bayes"

  require "newral/classifier/node"
  require "newral/classifier/node_distance"
  require "newral/classifier/dendogram"
  require "newral/classifier/k_means_cluster"

  require "newral/functions/base"
  require "newral/functions/line"
  require "newral/functions/vector"
  require "newral/functions/block"
  require "newral/functions/polynomial"
  require "newral/functions/gaussian"
  require "newral/functions/ricker_wavelet"
  require "newral/functions/radial_basis_function_network"
  
  require "newral/training/greedy"
  require "newral/training/hill_climbing"
  require "newral/training/linear_regression"
  require "newral/training/linear_regression_matrix"
  require "newral/training/gradient_descent"
  require "newral/q_learning/base"

  require "newral/genetic/tree"
  require "newral/graphs/node"
  require "newral/graphs/edge"
  require "newral/graphs/graph"
  require "newral/graphs/path"
  require "newral/graphs/tree_search"
  require "newral/graphs/cheapest_first"
  require "newral/graphs/a_star"
end