module RecallChecker
  module Adaptors
    class Base
      include HTTParty
      
      @@adaptors = {}

      class << self
        def make make
          @@adaptors[make] = self
        end
      
        def find_by_make_and_vin make, vin
          @@adaptors[make].new(vin)
        end

        def supported? make
          @@adaptors.include? make
        end
      end

      def initialize vin
        @vin = vin
      end

      def options
        {query: {vin: @vin}}
      end

      def response
        @response ||= self.class.get("", options)
      end

      def parsed_response
        @parsed_response ||= response.parsed_response
      end
      
    end
  end
end