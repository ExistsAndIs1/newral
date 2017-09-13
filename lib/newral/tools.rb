module Newral
  
  module Tools

    module Errors 
      class NoElements < StandardError; end
    end 

    def self.mean( array )
      array.sum.to_f/array.length
    end 

    def self.sigma( array )
      mean = self.mean( array )
      sigma_square = array.inject(0){ |value,el| value+(el-mean)**2 }
      (sigma_square/array.length)**0.5
    end

    def self.normalize( data, high: nil, low:nil,normalized_high:1,normalized_low:-1)
      unless high && low 
        data.sort!
        high ||= [data[data.length-1],data[0].abs].max
        low  ||= data[0] >= 0 ? data[0] : [high*-1,data[0]].min
      end 
      data.collect do |data_point|
        (data_point-low)/(high-low).to_f*(normalized_high-normalized_low)+normalized_low
      end
    end

    def self.denormalize( data, high: nil, low:nil,normalized_high:1,normalized_low:-1)
      normalize( data, normalized_high: high, normalized_low: low, high: normalized_high, low: normalized_low)
    end 

    def self.euclidian_distance( v1, v2 )
      total = 0.0
      v1.each_with_index do   |value,idx|
        total=total+(value-v2[idx])**2
      end
      total**0.5
    end

    def self.max_distance( v1, v2 )
      max = 0.0
      v1.each_with_index do   |value,idx|
        dist=(value-v2[idx]).abs
        max = dist unless max > dist 
      end
      max
    end

    def self.taxi_cab_distance( v1, v2 )
      total = 0.0
      v1.each_with_index do   |value,idx|
        total=total+(value-v2[idx]).abs
      end
      total
    end

    def self.sort_and_slice( distances, number_of_entries:5,element_at_index:1 )
        distances.sort do |v1,v2|
          v1[ element_at_index ]<=>v2[ element_at_index ]
        end[0..number_of_entries-1]
    end 

    # point is a vector
    # clusters have a key , values are an array of point
    # we iterate over all points and return the closest ones 
    # as an Array of [key,distance,point]
    # to classify you can then count the nearest neighbours by key or use the weighted k_nearest_neighbour approach
    def self.k_nearest_neighbour( point, clusters, number_of_neighbours: 5 )
      distances = []
      
      clusters.each do |key,values|
        values.each do |value|
          # we optimize here by sorting on insert, or sort and slice after distances
          # array exceeds number_of_neighbours*5
          distances = sort_and_slice( distances, number_of_entries: number_of_neighbours ) if distances.length > number_of_neighbours*5
          distances << [key,euclidian_distance( point, value ),value]
        end
      end
      sort_and_slice( distances, number_of_entries: number_of_neighbours )
    end

    # input: array of samples which lead to positive result
    # example movies user likes with 3 properties action, comedy, romance 
    #  [[1,0,1],[0,0,1]] => user likes action+romance, romance 
    # output  be [0,-1,1] => action y/n does not matter, comedy no, romance yes
    def self.more_general_than_or_equal( samples )
      hypotheses=[-1]*samples.first.length
      samples.each do |sample|
        sample.each_with_index do |v,idx|
          if v == 1
            hypotheses[idx] = 1 unless hypotheses[idx] == 0
          else 
            hypotheses[idx] = 0 if hypotheses[idx] == 1
          end
        end
      end
      hypotheses
    end

   # input: array of samples which lead to negative result
    # example movies user does not likes with 3 properties action, comedy, romance 
    #  [[1,0,1],[0,0,1]] => user does not like action+romance, romance 
    # output  be [-1,1,-1] => action no, romance no
    def self.general_to_specific( samples )
      hypotheses=[0]*samples.first.length
      samples.each do |sample|
        sample.each_with_index do |v,idx|
          if v == 1
            hypotheses[idx] = -1 unless hypotheses[idx] == 1
          else 
            hypotheses[idx] = 1 if hypotheses[idx] == 0
          end
        end
      end
      hypotheses
    end

 

    # https://youtu.be/_DhelJs0BFc?t=4m10s
    # http://keisan.casio.com/exec/system/1180573188
    def self.gaussian_density( x, mu: nil , sigma: nil, elements:nil )
      raise Errors::NoElements if ( mu.nil?  || sigma.nil? ) && elements.nil?
      mu = mean(  elements ) unless mu 
      sigma = sigma(  elements ) unless sigma 
      (1.0/((2*Math::PI)**0.5*sigma.to_f))*Math.exp((-1.0/2)*((x-mu)**2/sigma.to_f**2 ))
    end 


  end


end