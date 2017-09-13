module Newral
  module Training
    class LinearRegressionMatrix
      #https://stackoverflow.com/questions/24747643/3d-linear-regression
      attr_reader :best_function, :best_error, :input
      def initialize( input: [], output: [] )
        @input = input
        @output = output
      end


      def process(  )
        # @input = [[6 ,4 ,11],[  8 ,5 ,15],[  12, 9, 25],[ 2, 1, 3]]
        # @output = [20,30,50,7]
        array = @input.collect do |input| 
           [1]+input
        end
        matrix = Matrix.rows array
        result = (( matrix.transpose*matrix ).inverse*(matrix.transpose)).to_a
        
        weights = result.collect do |r|
          r.size.times.inject(0) { |sum,i| sum = sum + r[i] * @output[i] }
        end
        bias = weights[0]
        @best_function = Newral::Functions::Vector.new vector: weights[1..weights.length-1], bias: bias 
        @best_error =@best_function.calculate_error( input: @input, output: @output )
        @best_function
      end
        
    end 
  end 
end  