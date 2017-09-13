module  Newral
  module Functions
    module Errors
      class NoBlock < ::StandardError; end 
    end 
    attr_reader :calculate_block
    # as its ruby we of course have to also offer the possibility for blocks
    class Block < Base
      
      def initialize( directions:0, params:[], &block )
        raise Errors::NoBlock unless block_given?
        @calculate_block = block
        @params = params
        @directions = directions || params.size
      end 

      def calculate( input ) 
        @calculate_block.call input, @params 
      end

      def move( direction: 0, step:0.01, step_percentage: nil )
        raise Errors::InvalidDirection unless direction >0 && direction<@directions
        @params[direction]=(step_percentage ? @params[direction]*(1+step_percentage.to_f/100) : @params[direction]+step )
        self
      end

      def number_of_directions 
        @directions
      end

  
    end
  end
end