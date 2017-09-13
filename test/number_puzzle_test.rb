require 'test_helper'
include Newral
class  NumberPuzzleTest < Minitest::Test

  class NumberPuzzleNode < Newral::Graphs::Node
    def initialize( matrix )
      @matrix = matrix
      @y = matrix.size
      @x= matrix.first.size 
      @posx_empty
      matrix.each_with_index do |row,idx|
        if found = row.index( 'empty' )
          @posy_empty = idx
          @posx_empty = found
        end 
      end
    end 

    def name 
      @matrix.collect{ |row| row.join( '|' ) }.join("#")
    end

    def swap( pos_x1, pos_y1, pos_x2, pos_y2 )
      new_matrix = nil
      if @matrix[pos_y1] &&  @matrix[pos_y1][pos_x1] && @matrix[pos_y2] && @matrix[pos_y2][pos_x2]
        new_matrix = @matrix.collect{ |row| row.dup } 
        new_matrix[pos_y1][pos_x1] = @matrix[pos_y2][pos_x2]
        new_matrix[pos_y2][pos_x2] = @matrix[pos_y1][pos_x1]
      end
      new_matrix
    end 

    # returns number of nodes possible from here
    def move 
      [
        swap( @posx_empty, @posy_empty, @posx_empty-1,@posy_empty ),
        swap( @posx_empty, @posy_empty, @posx_empty+1,@posy_empty ),
        swap( @posx_empty, @posy_empty, @posx_empty,@posy_empty-1 ),
        swap( @posx_empty, @posy_empty, @posx_empty,@posy_empty+1 )
      ].compact.collect do |matrix|
        self.class.new( matrix )
      end
    end 

    def shuffle( moves: 15 )
      shuffled = self
      moves.times do |i|
        new_elems = shuffled.move
        shuffled = new_elems[rand( new_elems.length )]
      end
      shuffled
    end 

    def ==( other )
      other.name == self.name
    end

  end

  class NumberPuzzle < Newral::Graphs::Graph
    attr_reader :start_node, :end_node
    def initialize( x: 4, y: 4 )
      super nodes:[], edges:[]
      @end_matrix = []
      for i in 1..y
        row=[]
        for j in 1..x 
          row << ( i==x && j==y ? 'empty' : (i-1)*x+j )
        end 
        @end_matrix << row
      end 
      @end_node = NumberPuzzleNode.new( @end_matrix )
      @start_node = @end_node.shuffle
      @nodes << @end_node
    end 

    def find_edges( node )
      nodes = node.move
      nodes.collect do |end_node|
        Newral::Graphs::Edge.new( node, end_node, cost: 1 )
      end
    end

  end 

end 