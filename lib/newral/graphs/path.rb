module Newral
  module Graphs
    module Errors 
      class CanOnlyConnectToLastEdge < ::StandardError; end 
      class CircularPath < ::StandardError; end 
    end 

    class Path
      attr_reader :edges
      def initialize( edges:[], allow_circular_paths: true )
        @edges = edges.dup
        @allow_circular_paths = allow_circular_paths
      end

      def add_edge( edge )
        last_edge = @edges.last 
        raise Errors::CanOnlyConnectToLastEdge,[last_edge,edge] unless  @edges.empty? || last_edge.end_node == edge.start_node 
        raise Errors::CircularPath unless @allow_circular_paths && !@edges.index{|edge1| edge1.start_node == edge.end_node || edge1.end_node == edge.end_node }
        @edges << edge   
        self  
      end

      def length 
        @edges.length 
      end 

      def cost 
        @edges.inject(0){ |value,edge| value+edge.cost }
      end 


      def start_node
        @edges.first.start_node
      end 


      def end_node
        @edges.last.end_node
      end 

      def to_s
        @edges.join(', ')
      end

    
      
  
    end
  end
end