module RecallChecker
  module Adaptors
    class Base
      include HTTParty
      
      @@adaptors = {}

      def self.make make
        @@adaptors[make] = self
      end
      
      def self.find_by_make_and_vin make, vin
        @@adaptors[make].new(vin)
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
      
    end
  end
end