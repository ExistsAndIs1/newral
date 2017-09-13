module Newral
  
    module Classifier
      
   
      class Node 
  
        attr_writer :parent_node 
        attr_accessor :center
        attr_reader :sub_nodes
        def initialize( sub_nodes, from_point: false )
          if from_point
            @sub_nodes = [Vector.elements( sub_nodes )]
            @center = Vector.elements sub_nodes 
          else 
            @sub_nodes = sub_nodes
            @center = Vector.elements( [0]*sub_nodes.first.center.size )
            sub_nodes.each do |node|
              @center = @center + node.center
            end
            @center = @center/@sub_nodes.size.to_f
            @sub_nodes.each do |node|
              node.parent_node = self 
            end
          end
          @parent_node = nil
         
        end
  
        def to_s
          if @sub_nodes.size == 1
            @sub_nodes.first.to_s
          else
            "=>(#{@sub_nodes.collect{|node| node.to_s }.join(',')})"
          end
        end
  
        def flatten_points
           @sub_nodes.collect do |node|
            if !node.kind_of?( Node )
              [node]
            elsif node.sub_nodes.size == 1 
              node.center 
            else
              node.flatten_points
            end
          end.flatten
        end 
  
        def to_cluster 
          points = flatten_points
          Data::Cluster.new( points: points.collect{|p| p.to_a } )
        end
  
  
    end 
  end 
end