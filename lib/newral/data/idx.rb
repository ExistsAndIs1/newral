module Newral
  module Data
    require "open-uri"
    module Errors 
      class UnexpectedEOF < StandardError; end 
      class EOFExpected < StandardError; end 
      class LabelsNotMatchingItems < StandardError; end 
    end 

    class Idx < Base
      # http://yann.lecun.com/exdb/mnist/
      # used for Handwritten Images
      def initialize( file_name: nil, label_file_name: nil )
        @file_name = file_name
        @label_file_name = label_file_name
        super( inputs: [], outputs: [])
      end 

      def process
        number_of_items = 0
        open( @file_name, 'rb' ) do |file|
          magic,number_of_items = file.read(8).unpack("NN")
          width,height = file.read(8).unpack("NN")
          number_of_items.times do 
            raise Errors::UnexpectedEOF if file.eof?
            image = file.read(width*height).unpack("C"*width*height)
            @inputs << image 
          end 
          raise Errors::EOFExpected unless file.eof?
        end

        open( @label_file_name, 'rb' ) do |file|
          magic,number_of_labels = file.read(8).unpack("NN")
          raise Errors::LabelsNotMatchingItems unless number_of_labels==number_of_items
          number_of_items.times do 
            raise Errors::UnexpectedEOF,"#{ @outputs.size } vs. #{ number_of_labels }" if file.eof?
            label = file.read(1).unpack("c").first
            @outputs << label 
          end 
          raise Errors::EOFExpected,"#{ @outputs.size } #{file.read.size}" unless file.eof?
        end


      end
    
    end
  end
end#