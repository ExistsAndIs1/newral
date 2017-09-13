module Newral
  module Training
    class LinearRegression
      #https://viblo.asia/p/machine-learning-algorithms-from-scratch-with-ruby-linear-regression-RnB5p1aYKPG
      attr_reader :best_function, :best_error, :input
      def initialize( input: [], output: [] )
        @input = input
        @output = output
      end


      def process(  )
        input_mean=Newral::Tools.mean @input
        output_mean =Newral::Tools.mean @output
        dividend =0
        divisor = 0
        @input.each_with_index do |input,idx|
         dividend = dividend+(input-input_mean)*( @output[idx]-output_mean)
         divisor = divisor+(input-input_mean)**2 
        end 
        multiplier = dividend/divisor
        error = output_mean-multiplier*input_mean
        @best_function = Newral::Functions::Polynomial.new(factors: [multiplier,error])
        @best_error =@best_function.calculate_error( input: @input, output: @output )
        @best_function
      end
        
    end 
  end 
end  