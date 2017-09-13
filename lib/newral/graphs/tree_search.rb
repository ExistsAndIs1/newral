module Newral
  module Graphs
    module Errors 
      class FrontierEmpty < StandardError; end
    end 
    # the algorithms are heavily inspired by the Udacity course from
    # Sebastian Thrun https://classroom.udacity.com/courses/cs271
    class TreeSearch 
      attr_reader :frontier
      def initialize( graph: nil, start_node: nil, end_node: nil  )
        @graph = graph 
        @start_node = start_node
        @end_node = end_node 
        path = Path.new(edges:[ Edge.new( start_node: start_node, end_node: start_node, directed: true, cost:0 )])
        @explored = {end_node: 0 }
        @frontier = [ path ]
      end

      def run

        while @frontier.length > 0 
          path = remove_choice
          return path if path.end_node == @end_node
          edges = @graph.find_edges( path.end_node)
          puts "no edges found for #{path.end_node.name} #{@graph.edges.length}" unless edges.length > 0
          edges.each do |edge|
            begin
              end_node = edge.start_node == path.end_node ? edge.end_node : edge.start_node
              new_edge = Edge.new( start_node: path.end_node, end_node: end_node, directed: true, cost: edge.cost )
              puts( "n:#{ new_edge.to_s } e:#{edge} n:#{end_node} s:#{path.end_node} #{edge.start_node == new_edge.end_node } #{edge.end_node}")
              new_path = Path.new(edges:path.edges).add_edge( new_edge )
              if  @explored[new_path.end_node].nil? ||  measure( path  ) < @explored[new_path.end_node]
                @frontier << new_path
                @explored[ new_path.end_node ] = measure( new_path )
              end
            rescue Errors::CircularPath
              puts "circular #{ new_path.to_s }"
              # no need to check this path
            end
          end
        end
        raise Errors::FrontierEmpty 
      end

      def remove_choice
        @frontier.sort! do |path1,path2|
          measure( path2 ) <=> measure( path1 ) # reverse 
        end
        puts "frontier: #{@frontier.length}"
        @frontier.pop # pops shortest
      end

      # the standard approach is breath first
      def measure( path )
        path.length
      end 
      
    end 
  end
end