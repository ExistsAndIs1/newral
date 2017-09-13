module  Newral
  module Functions
    class RickerWavelet < Gaussian
      # The mexican sombrero function

      def calculate_for_center_distance( vector1  ) 
        distance = Newral::Tools.euclidian_distance( vector1, @center )
        (1-distance**2)*Math.exp(-distance.to_f**2/2)*@factor
      end

    end
  end
end