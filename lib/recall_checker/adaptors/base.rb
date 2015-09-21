module RecallChecker
  module Adaptors
    class Base
      include HTTParty

      @@adaptors = {}
      FIELDS = {}

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

      def fields
        %w(title nhtsa_id manufacturer_id description risks remedy status notes created_at updated_at)
      end
      
      def lookup_field field
        self.class::FIELDS.fetch(field, field)
      end

      def has_recalls?
        recalls_raw.any?
      end

      def request
        self.class.get(url, options)
      end

      def response
        @response ||= request
        raise VinError if vin_invalid?
        @response
      end

      def parsed_response
        response.parsed_response
      end

      def recalls_raw
        parsed_response.fetch('recalls', [])
      end
      
      def recalls
        recalls_raw.map do |recall|
          Hash[fields.map do |field|
            converter = "convert_#{field}"
            value = respond_to?('htmlpage') ? recall : recall.fetch(lookup_field(field))
            [field, respond_to?(converter) ? send(converter, value) : value ]
          end]
        end
      end
      
      def convert_created_at time
        Time.parse(time)
      end

      def convert_updated_at time
        Time.parse(time)
      end
    end
  end
end