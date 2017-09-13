module Newral
  module Data 
    require "CSV"
    require "open-uri"
    class Csv < Base
      def initialize( file_name: nil, output_fields: 1 )
        @file_name = file_name
        @output_fields = output_fields
        super( inputs: [], outputs: [])
      end 

      def process
        open( @file_name ) do |file|
          file.each_line do |line|
            input = CSV.parse_line( line ).collect{ |field| field.match(/^\d*\.?\d+$/) ? field.to_f : field }
            add_input( input.slice(0,input.size-1-@output_fields), output: input.slice(input.size-@output_fields, input.size ))
          end
        end
      end
    
    end
  end
end