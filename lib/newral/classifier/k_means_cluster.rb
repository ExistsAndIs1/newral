module Newral
  
    module Classifier
          
      class KMeansCluster 

        # input array of points, cluster_labels: how many clusters to find, max_iterations stop after x approximations
        # output hash of clusters where has keys are cluster_labels and value is points(Array) and center(point) 
        def initialize( points, cluster_labels: [:a,:b], max_iterations: 20 )
          @points = points
          @cluster_labels = cluster_labels
          @max_iterations = max_iterations
        end 

        def process 
          @cluster_set = Newral::Data::ClusterSet.new( cluster_labels: @cluster_labels )
          runs = 0
          @points.sample( @cluster_set.cluster_array.length ).each_with_index do |point,idx|
            @cluster_set.cluster_array[ idx ].center = point
          end 
    
          while @cluster_set.cluster_array.collect{ |cluster| cluster.moved }.member?( true ) && runs < @max_iterations
            @cluster_set.clusters.each do |key,cluster|
              cluster.points=[] 
            end
     
            # iterate over points assign, best cluster
            @points.each do |point|
              min_distance =  { cluster:'none', distance: 99**99 }
              @cluster_set.clusters.each do |key,cluster|
                distance = Newral::Tools::euclidian_distance( cluster.center, point )
                min_distance = {cluster: cluster, distance: distance } if distance < min_distance[:distance]
              end
              min_distance[:cluster].add_point point
            end
            @cluster_set.update_centers
            runs=runs+1
          end
          @cluster_set
        end 

      end

    end
  end 
