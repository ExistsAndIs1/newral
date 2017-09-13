module Newral
  module Data 
    class Cluster
      attr_accessor :label, :points, :center, :moved
      def initialize( label: nil, points: [], center: nil, moved: true )
        @label = label
        @points = points
        @point_size = points.size > 0 ? points.first.size : 1
        @moved = moved # did center move when updating it
        @center = center
      end 

      def add_point( point )
        if @points.size == 0
          @point_size = point.size
          @center ||= point
        else
          # all points must be of same dimension
          raise Errors::WrongPointDimension unless point.size == @point_size 
        end
        @points << point 
        self
      end 

      def update_center
        return unless @points.size > 0
        new_center = Vector.elements( [0]*points.first.size )
        @points.each do |point| 
          new_center = new_center + Vector.elements( point )
        end 
        new_center = ( new_center/@points.size.to_f).to_a
        @moved = new_center != @center
        @center = new_center
      end 
    end
  end
end