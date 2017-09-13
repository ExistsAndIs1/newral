module Newral
  module Graphs
    class CheapestFirst < TreeSearch 
    
     def measure( path  )
        path.cost 
     end

    end
  end 
end 