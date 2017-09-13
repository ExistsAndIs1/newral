module Newral
  module Graphs
    class Edge
      attr_accessor :start_node, :end_node, :directed, :cost, :data
      def initialize( key:nil, start_node: nil, end_node: nil, directed: false, cost: nil, data:nil )
        @key = key
        @start_node = start_node
        @end_node = end_node
        @directed = directed
        @cost = cost
        @data = data
        
      end

      def key 
        @key || "#{ @start_node }#{ directed ? '=>' : '<=>' }#{ @end_node }"
      end

      def to_s 
        key
      end 
    end
  end
end