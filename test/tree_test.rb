
require 'test_helper'
include Newral
class TreeTest < Minitest::Test
  def test_simple_tree
    t1= Newral::Genetic::Tree.new( value: 3 )
    assert_equal t1.eval,3
    t2= Newral::Genetic::Tree.new( value: 3 )

    t3 =  Newral::Genetic::Tree.new( value: '+', left_child: t1, right_child: t1 )
    assert_equal t3.eval,6   
  end

  

end

