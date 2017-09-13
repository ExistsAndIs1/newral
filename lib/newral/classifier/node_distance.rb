module Newral
  
    module Classifier
      class NodeDistance 
        attr_reader :node1, :node2, :distance
        def initialize( node1, node2 )
          @node1 = node1 
          @node2 = node2 
          @distance = Newral::Tools.euclidian_distance( node1.center, node2.center )
        end

        def <=>( other )
          self.distance <=> other.distance
        end 

      end
    end

end 