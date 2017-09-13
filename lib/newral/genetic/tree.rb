module Newral
  module Genetic
    class Tree
      attr_reader :value, :left_child, :right_child, :sub_node_count
      attr_accessor :parent
      OPERANDS = { 
        '+' => 2,
        '*' => 2,
        '/' => 2,
        '-' => 2,
        'pow' => 2, 
        'sqrt' => 1
      }
      def initialize( parent: nil, value:nil, right_child: nil, left_child: nil )
        @parent = parent
        @left_child = left_child
        @right_child = right_child
        update_node_count
        @value = value
      end     

      def update_node_count 
        @sub_node_count = ( @left_child && 1 ).to_i+( @left_child && @left_child.sub_node_count ).to_i+( @right_child && 1 ).to_i+( @right_child && @right_child.sub_node_count ).to_i
        @parent.update_node_count if @parent
        @sub_node_count
      end 

      def node_count 
        @sub_node_count+1
      end

      def set_child_trees( left_child: nil, right_child: nil, force: false )
        @left_child = left_child if left_child || force
        @right_child = right_child if right_child || force
        @right_child.parent = self if @right_child
        @left_child.parent = self if @left_child
        update_node_count
        self
      end

      def eval
        case @value 
          when '+' then @left_child.eval+@right_child.eval
          when '-' then @left_child.eval-@right_child.eval
          when '*' then @left_child.eval*@right_child.eval
          when '/' then @left_child.eval/@right_child.eval
          when 'pow' then @left_child.eval**@right_child.eval
          when 'sqrt' then @left_child.eval**0.5
        else 
          @value
        end
      end

      def self.full_tree( depth:3, allowed_operands: OPERANDS.keys, terminal_nodes:[]  )
        if depth > 1
          value =  allowed_operands[ rand(allowed_operands.size) ]
          tree = Tree.new( value: value )
          tree.set_child_trees( left_child: Tree.full_tree( depth: depth-1, allowed_operands: allowed_operands, terminal_nodes: terminal_nodes ))
          if OPERANDS[value] == 2 
            tree.set_child_trees( right_child: Tree.full_tree( depth: depth-1, allowed_operands: allowed_operands, terminal_nodes: terminal_nodes ))
          end
          tree
        else 
          Tree.new( value: terminal_nodes[rand(terminal_nodes.size)])
        end
      end 

    end
  end
end