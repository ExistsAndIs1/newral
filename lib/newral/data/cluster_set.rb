module Newral
  module Data 
    class ClusterSet
      attr_accessor :clusters
      def initialize( cluster_labels: [], clusters: nil )
        if clusters 
          idx = 0
          @clusters = clusters.inject({}){ |h,cluster| cluster.label = "cluster_#{ idx }";h[cluster.label] = cluster;idx=idx+1; h }
        else 
          @clusters = cluster_labels.inject({}){ |h,label| h[label] = Cluster.new(label: label); h }
        end
      end 

      def []( label )
        label.kind_of?(String) || label.kind_of?(Symbol)  ? @clusters[ label ] : cluster_array[ label ]
      end 

      def cluster_array
        @clusters.values
      end

      def update_centers
        @clusters.each do |key,cluster| 
          cluster.update_center
        end 
      end

      def clusters_count
        @clusters.inject({}) do |h,cluster|
          h[cluster[0]] = cluster[1].points.size
          h 
        end 
      end


    end
  end
end