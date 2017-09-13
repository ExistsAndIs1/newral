module Newral
  module ErrorCalculation
   class DimensionsNotMatching < StandardError ; end 
    def self.sum_of_squares( results, expected )
      sum = 0
      raise DimensionsNotMatching, "results: #{ results.size } expected: #{ expected.size }" unless expected.size == results.size 
      results.each_with_index do |result,idx|
        Array(result).each_with_index do |r,r_idx|
          exp = Array(expected[idx])
          sum = sum+(r-exp[r_idx])**2
        end
      end
      sum
    end 

    def self.root_mean_square( results, expected )
      sum = sum_of_squares( results, expected )
      (sum.to_f/results.size)**0.5
    end 

    def self.mean_square( results, expected )
      sum = sum_of_squares( results, expected )
      sum.to_f/results.size
    end
    
    
  end
end