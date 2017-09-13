module Newral
  module Data 
    module Errors
      class InputOutputSizeMismatch < ::StandardError; end 
      class WrongPointDimension < ::StandardError; end 
      class UnknownValue < ::StandardError; end 
      class UnknownSet < ::StandardError; end 
      class UnknownCategory < ::StandardError; end 
      class DownSamplingImpossible < ::StandardError; end 
    end

    class Base
      attr_accessor :outputs, :labels, :inputs
      def initialize( inputs: [], outputs: [], labels:[] )
        @inputs = inputs
        @outputs = outputs
        @labels = labels
        raise Errors::InputOutputSizeMismatch unless @inputs.size == @outputs.size
      end 

      def add_input( input, output: nil, label:nil )
        @labels << label
        @outputs << output
        @inputs << input
      end

      def sub_set( set: :inputs, category: :all )
        data = case set
          when :inputs then @inputs
          when :outputs then @outputs 
          else
            raise Errors::UnknownSet
          end 
        
        case category
          when :all then data 
          when :training then data[0..(data.size.to_f*0.7).to_i]
          when :validation then  data[(data.size.to_f*0.7).to_i+1..(data.size.to_f*0.8).to_i ]
          when :testing then  data[(data.size.to_f*0.8).to_i+1,data.size ]
        else
          raise Errors::UnknownCategory, category.to_s
        end
      end 

      def values_for( searched_value, only_first: false, return_objects: [], search_objects: [] )
        results = []
        search_objects.each_with_index do |each_value,idx|
          if only_first 
            return return_objects[idx] if searched_value == each_value || [searched_value] == each_value
          else 
            results << return_objects[idx] if searched_value == each_value || [searched_value] == each_value
          end
        end
        results unless only_first
      end 

      def output_for_input( input )
        values_for input, search_objects: @inputs, return_objects: @outputs, only_first:  true 
      end

      def label_for_input( input )
        values_for input, search_objects: @inputs, return_objects: @labels, only_first:  true
      end

      def inputs_for_output( output )
        values_for output, search_objects: @outputs, return_objects: @inputs
      end

      def normalized_inputs(normalized_high: 1, normalized_low:-1 )
        return [] if @inputs.size == 0 || !@inputs.first.kind_of?( Array )
        max_values = [Float::MIN]*@inputs.first.size
        min_values = [Float::MAX]*@inputs.first.size
        @inputs.each do |input|
          input.each_with_index do |value,idx|
            max_values[idx] = value.to_f if value > max_values[idx]
            min_values[idx] = value.to_f if value < min_values[idx]
          end
        end
        @inputs.collect do |input|
          row = [0]*input.size
          input.each_with_index do |value,idx|
            row[idx] = (value-min_values[idx])/(max_values[idx]-min_values[idx]).to_f*(normalized_high-normalized_low)+normalized_low
          end
          row 
        end
      end
      
      def output_hash( normalized_high: 1, normalized_low:-1 )
        @output_hash = @outputs.inject({}) do |hash,output|
          hash[output] = ( hash[output] || 0 )+1
          hash
        end 
        new_hash = {}
        @output_hash.keys.sort.each_with_index do |key,idx|
          new_hash[ key ] = normalized_low+((normalized_high.to_f-normalized_low)*idx)/( [@output_hash.keys.length-1,1].max )
        end 
        @output_hash = new_hash
      end 

      def output_normalized
         hash = output_hash
         @outputs.collect{ |k| hash[k]}
      end
      
      # this will make it easier to use outputs for neura networks
      # as it translates them to vectors like [1,0,0]
      # if you have 3 possible outputs this will return [1,0,0],[0,1,0],[0,0,1]
      def output_as_vector( category: :all )
        hash = output_hash
        sub_set( set: :outputs, category: category ).collect do  |k| 
          vector = [0]*output_hash.keys.size
          vector[ output_hash.keys.index( k ) ] = 1 # output_hash.keys 
          vector
        end 
      end 
        
      def count_outputs
        output_hash = {}
        @outputs.each do |output| 
          output_key = output.size == 1 ? output.first.to_s.to_sym : output.join('-')
          output_hash[output_key] = (output_hash[output_key] || 0) + 1
        end
        output_hash 
      end

      def sample( offset:0,limit:100 )
        Base.new( inputs:  @inputs[offset..limit+offset] , outputs: @outputs[offset..limit+offset] )
      end 

      def downsample_input!( height:1, width: 1, width_of_line: nil )
        raise DownSamplingImpossible unless @inputs.first.size % ( width*height ) == 0
        total_height = @inputs.first.size/width_of_line
        
        @inputs.collect! do |input| 
          downsampled = []
          pos = 0
          while pos < input.size do 
            matrix = []
            height.times do |h|
              start_pos = pos+(width_of_line*h)
              end_pos = pos+width+(width_of_line)*h-1
              matrix = matrix+input[start_pos..end_pos]
            end 
            downsampled << (  matrix.inject(0){|sum,e| sum+e }/matrix.length.to_f > 0.5 ? 1 : 0 )
            pos = pos+width
            pos=pos+width_of_line*(height-1) if (pos%width_of_line) == 0
          end
          downsampled 
        end 
      end 
    end
  end 
end