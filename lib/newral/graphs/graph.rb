module Newral
  module Graphs
    module Errors 
      class UnknownNode < StandardError; end
    end 
    class Graph
      attr_reader :nodes, :edges
      def initialize( nodes: [], edges: [] )
        @nodes = nodes
        @edges = edges
      end
      
      def add_edge( edge )
        unless @nodes.member?( edge.start_node ) && @nodes.member?( edge.end_node )
          # let´s try to find it 
          @nodes.each do |node|
            edge.start_node = node if node.respond_to?( :name ) && node.name == edge.start_node
            edge.end_node = node if node.respond_to?( :name ) && node.name == edge.end_node
          end 
          raise Errors::UnkownNode unless @nodes.member?( edge.start_node ) && @nodes.member?( edge.end_node )
        end
        @edges << edge 
        self
      end 

      def add_node( node )
        @nodes < node 
        self
      end

      def add_nodes( nodes )
        @nodes = @nodes+nodes
        self
      end

      def find_node_by_name( name )
        @nodes.find{ |node| node.name == name }
      end

      # we can add also like this {1=> 2, 2 => 5 }
      def add_edges( edges, directed: false )
        if edges.kind_of?( Hash )
          edges.each do |from,to|
            @edges << Edge.new( start_node: from, end_node: to, directed: directed )
          end 
        else 
          edges.each do |edge|
            add_edge edge
          end
        end
        self
      end

      def find_edges( node )
        @edges.collect do |edge| 
          keep = edge.directed ? edge.start_node == node : edge.start_node == node || edge.end_node == node
          edge if keep
        end.compact
      end 

    end 
  end
end