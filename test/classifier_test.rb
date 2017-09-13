
require 'test_helper'
include Newral
class ClassifierTest < Minitest::Test
  
    def test_k_means_cluster 
      data = get_test_data( :basic )
      classifier = Newral::Classifier::KMeansCluster.new( (data[:class1]+data[:class2]), cluster_labels:[:cluster1,:cluster2] )
      cluster_set = classifier.process
      assert_equal (data[:class1].size+data[:class2].size),cluster_set[:cluster1].points.size+cluster_set[:cluster2].points.size
      if cluster_set[:cluster1].points == data[:class1]
        assert_equal cluster_set[:cluster1].points, data[:class1]
        assert_equal cluster_set[:cluster2].points, data[:class2]
      else # we actually do not identify what it is, we just cluster, so depending on random starting point it will differ which cluster a point belongs to 
        assert_equal cluster_set[:cluster1].points, data[:class2],"#{cluster_set[:cluster1].points-data[:class2] } center: #{cluster_set[:cluster1].center} / #{cluster_set[:cluster2].center} "
        assert_equal cluster_set[:cluster2].points, data[:class1]
      end
      puts "c1: #{ cluster_set[:cluster1].center }"
      puts "c2: #{ cluster_set[:cluster2].center }"       
    end 

    def test_dendogram
      data = get_test_data( :basic )
      dendogram = Newral::Classifier::Dendogram.new( data[:class1]+data[:class2])
      nodes = dendogram.process.nodes
      assert_equal nodes.size,2
      cluster_set = dendogram.to_cluster_set
      if cluster_set[0].points == data[:class1]
        assert_equal cluster_set[0].points-data[:class1],[]
        assert_equal cluster_set[1].points-data[:class2],[]
      else
        assert_equal cluster_set[1].points-data[:class1],[], "#{ cluster_set[1].points } / #{data[:class1]} "
        assert_equal cluster_set[0].points-data[:class2],[]
      end

    end 



end

