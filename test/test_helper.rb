  $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
  require 'newral'

require 'minitest/autorun'

def basic_data
  class1 = [
        [1,1],[2,2],[3,3],[6,6]]
  class2 = [
        [10,10],[12,10],[13,12],[12,11]
  ]
  {class1: class1, class2: class2 }
end 

def get_test_data( set_name )
  basic_data
end

def assert_approximate( result, expected, allowed_error:0.1 )
  assert ( result && expected ) || ( result.nil? && expected.nil? )
  if result.kind_of?( Array )
    result.each_with_index do |r,idx| 
      assert (r-expected[idx]).abs < allowed_error, "#{ r } not as expected in #{ result } vs expected #{ expected } "
    end
  else 
      assert (result-expected ).abs < allowed_error, "#{ result } not as expected in #{ result } vs expected #{ expected } "
  end 
end 