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

      def url
        ""
      end

      def options
        url.empty? ? {query: {vin: @vin}} : {}
      end

      def response
        begin
          @response ||= self.class.get(url, options)
        rescue HTTParty::Error, Errno::ECONNREFUSED => e
          @response = {}
        end
      end

      def parsed_response
        @parsed_response ||= response.parsed_response
      end
      
    end
  end
end