
require 'test_helper'
include Newral
class FunctionsTest < Minitest::Test

  def test_block 
    func = Newral::Functions::Block.new( directions: 2, params:[1,1]) do |input,params|
      params[0]*input+params[1]*input
    end
    assert_equal func.calculate(1), 2
    assert_equal func.calculate(2), 4
  end

  def test_vector 
    func = Newral::Functions::Vector.new vector: [1,6], bias:1 
    assert_equal func.calculate([1,2]), 14
    assert_equal func.calculate([2,1]), 9
  end
end
