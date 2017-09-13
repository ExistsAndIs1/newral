
require 'test_helper'
include Newral
class  BayesTest < Minitest::Test
    # a NAND operator 
    # most simple Neural Net ever

    def test_create
      g = Newral::Graphs::Graph.new 
      g.add_nodes [1,2,3,4,5]
      g.add_edges({ 1 => 2,  3=> 4 })
      g.add_edges( {1=>3 })
      assert_equal 5,g.nodes.size
      assert_equal 3,g.edges.size
    end 

    def test_tree_search
      g = Newral::Graphs::Graph.new 
      g.add_nodes [1,2,3,4,5]
      g.add_edges({ 1 => 2,  3=> 4 })
      g.add_edges( {1=>3,4=>5 })
      g.add_edges( {4=>2})
      g.add_edges( {2=>8, 7=> 2, 9 => 2})

      t=Newral::Graphs::TreeSearch.new( graph: g, start_node: 1, end_node: 4) 
      t.run
    end 

    def test_breath_first
      edges,nodes,node_locations = setup_bulgarian_map
      g = Newral::Graphs::Graph.new 
      g.add_nodes nodes 
      g.add_edges edges
      t=Newral::Graphs::TreeSearch.new( graph: g, start_node: 'Arad', end_node:'Bucharest')
      path = t.run
      assert_equal 'Arad',path.start_node
      assert_equal 'Bucharest',path.end_node
      puts path.to_s
      assert_equal 4,path.length
      assert_equal 140+99+211,path.cost
    end


    def test_cheapest_first
      edges,nodes,node_locations = setup_bulgarian_map
      g = Newral::Graphs::Graph.new 
      g.add_nodes nodes
      g.add_edges edges
      t=Newral::Graphs::CheapestFirst.new( graph: g, start_node: 'Arad', end_node:'Bucharest')
      path = t.run
      assert_equal 'Arad',path.start_node
      assert_equal 'Bucharest',path.end_node
      puts path.to_s
      assert_equal 418,path.cost
    end

    def test_a_star
      edges,nodes,node_locations = setup_bulgarian_map
      g = Newral::Graphs::Graph.new 
      nodes = nodes.collect{|n| Newral::Graphs::Node.new(name:n, location: node_locations[n] ) } 
      g.add_nodes nodes
      g.add_edges edges
      t=Newral::Graphs::AStar.new( graph: g, start_node: g.find_node_by_name( 'Arad' ), end_node: g.find_node_by_name( 'Bucharest' ))
      path = t.run
      assert_equal 'Arad',path.start_node.name
      assert_equal 'Bucharest',path.end_node.name
      puts path.to_s
      assert_equal 418,path.cost
    end




    protected 

      def setup_bulgarian_map 
        nodes = %w( Arad Timisoara Lugoj Mehadia Drobeta Craiova Pitesti Rimnincu Sibiu Oradea Zerind Fagaras  Bucharest Urziceni Vaslui Iasi Neamt Hirsova Eforie )
        node_locations = {
          'Arad' =>  [0,100],
           'Timisoara' =>  [0,10] , 
           'Lugoj' =>  [10,10] , 
            'Mehadia'=>  [10,5] ,
            'Drobeta' =>  [10,0] ,
            'Craiova'  =>  [100,0] ,
            'Pitesti'=>  [120,25],
            'Rimnincu'=>  [100,30],
            'Sibiu' =>  [80,80],
             'Oradea' =>  [0,0],
             'Zerind' =>  [0,50],
            'Fagaras' =>  [120,80],
            'Bucharest' =>  [160,40],
             'Urziceni' =>  [180,50],
             'Vaslui' =>  [220,100],
            'Iasi'=>  [220,120],
             'Neamt' =>  [200,100],
              'Hirsova' =>  [220,50],
              'Eforie' =>  [230,0]

        }
        edges = []
        edges << Newral::Graphs::Edge.new( start_node: 'Arad', end_node: 'Sibiu', cost: 140 )
        edges << Newral::Graphs::Edge.new( start_node: 'Arad', end_node: 'Zerind', cost: 75 )
        edges << Newral::Graphs::Edge.new( start_node: 'Arad', end_node: 'Timisoara', cost: 118 )
        edges << Newral::Graphs::Edge.new( start_node: 'Oradea', end_node: 'Zerind', cost: 71 )
        edges << Newral::Graphs::Edge.new( start_node: 'Timisoara', end_node: 'Lugoj', cost: 111 )
        edges << Newral::Graphs::Edge.new( start_node: 'Mehadia', end_node: 'Lugoj', cost: 70 )
        edges << Newral::Graphs::Edge.new( start_node: 'Mehadia', end_node: 'Drobeta', cost: 75 )
        edges << Newral::Graphs::Edge.new( start_node: 'Drobeta', end_node: 'Craiova', cost: 120 )
        edges << Newral::Graphs::Edge.new( start_node: 'Craiova', end_node: 'Rimnincu', cost: 146 )
        edges << Newral::Graphs::Edge.new( start_node: 'Craiova', end_node: 'Pitesti', cost: 138 )
        edges << Newral::Graphs::Edge.new( start_node: 'Rimnincu', end_node: 'Pitesti', cost: 97 )
        edges << Newral::Graphs::Edge.new( start_node: 'Rimnincu', end_node: 'Sibiu', cost: 80 )
        edges << Newral::Graphs::Edge.new( start_node: 'Fagaras', end_node: 'Sibiu', cost: 99 )
        edges << Newral::Graphs::Edge.new( start_node: 'Oradea', end_node: 'Sibiu', cost: 151 )
        edges << Newral::Graphs::Edge.new( start_node: 'Bucharest', end_node: 'Pitesti', cost: 101 )
        edges << Newral::Graphs::Edge.new( start_node: 'Bucharest', end_node: 'Fagaras', cost: 211 )
        edges << Newral::Graphs::Edge.new( start_node: 'Bucharest', end_node: 'Urziceni', cost: 85 )
        [edges,nodes,node_locations] 
      end

end

