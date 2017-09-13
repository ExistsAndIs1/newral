
require 'test_helper'
include Newral
class DataTest < Minitest::Test
    # IRIS data set, no AI Tool can live without it
    def test_iris
      data = Newral::Data::Csv.new(file_name:File.expand_path('../fixtures/IRIS.csv',__FILE__))
      data.process
      assert_equal data.inputs.size,100
      assert_equal data.inputs_for_output('setosa').size,32
      assert_equal data.inputs.size, data.normalized_inputs.size 
    end

    def test_downsample 
      input = [[
        6,1,0,0,1,1,
        1,0,0,0,1,0,
        1,7,0,0,1,1,
        6,0,0,0,1,0
      ]]
      data = Newral::Data::Base.new( inputs: input, outputs:[1] )
      assert_equal data.downsample_input!(width:2, height:2,width_of_line:6 ), [[1, 0, 1, 1, 0, 1]]
      
end

