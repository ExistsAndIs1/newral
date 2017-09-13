module Newral
  module Graphs
    class Node 
      attr_reader :name, :location
      def initialize( name: nil, location: nil )
        @name = name
        @location = location
      end
    end 
  end
end