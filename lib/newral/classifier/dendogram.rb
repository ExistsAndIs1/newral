module Newral

  module Classifier
        
    class Dendogram 
      attr_reader :nodes, :max_distance, :distances
      def initialize( points, max_runs: 100, abort_at_distance: 0.5 )
        @distances = []
        @abort_at_distance = abort_at_distance
        @max_runs = max_runs
        @nodes = points.collect{ |point| Node.new( point, from_point: true ) }
       end

      def process
        runs = 0
        @nodes.each do |node|
          calculate_distances( node )
        end
        @distances.sort!
        @max_distance = @distances.last.distance 
        while @distances.size > 2 && @distances.first.distance/@max_distance < @abort_at_distance && runs < @max_runs
          combine_nodes( @distances.first.node1, @distances.first.node2 )
          runs = runs+1
        end
        self
      end

      def calculate_distances( node )
        @nodes.each do |other_node|
          @distances << NodeDistance.new( node, other_node ) unless node==other_node
        end
      end 

      def combine_nodes( node1, node2 )
        new_node = Node.new([node1,node2])
        node1.parent_node = new_node
        node2.parent_node = new_node
        
        # remove node1 and node2 
        @nodes = @nodes.collect do |node| 
          node unless node == node1 || node == node2
        end.compact
        # remove distances for these 2 nodes 
        @distances = @distances.collect do |distance|
          distance unless distance.node1 == node1 || distance.node1 == node2 || distance.node2 == node2 || distance.node2 == node1
        end.compact

        # insert new node
        @nodes << new_node 
        # calculate_distances for new node 
        calculate_distances( new_node )
        @distances.sort!
      end 

      def to_s 
        @nodes.collect do |node|
          node.to_s
        end.join(" / ")
      end

      def to_cluster_set
        clusters = @nodes.collect{|node| node.to_cluster }
        Data::ClusterSet.new( clusters: clusters )
      end
    end

  end 
end 