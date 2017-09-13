module Newral
  module Graphs
    class AStar < TreeSearch 
    
     
     def measure( path  )
        path.cost + Newral::Tools.euclidian_distance( @end_node.location, path.end_node.location )
     end

    end
  end 
end 