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
          @@adaptors[make.downcase.tr('^a-z0-9', '')].new(vin)
        end

        def supported? make
          @@adaptors.include? make
        end
      end

      def initialize vin
        @vin = vin.upcase
        raise VinError, "Invalid VIN format: #{vin}" if !VINValidator.format_valid?(@vin)
        # Uncomment this if you need to implement local validation by the check digit
        # raise VinError, "Invalid check digit in the VIN: #{vin}" if !VINValidator.check_digit_valid?(@vin)
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
        raise VinError, "VIN is not recognized by the manufacturer: #{@vin}" if vin_invalid?
        @response
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ETIMEDOUT => e
        raise ConnectionError, e
      end

      def parsed_response
        response.parsed_response
      end

      def recalls_raw
        if respond_to?('recalls_html')
          recalls_html.map do |recall|
            Hash[fields.map do |field| 
              retriever = "retrieve_#{field}"
              [field, respond_to?(retriever) ? send(retriever, recall) : nil]
            end]
          end
        else
          parsed_response.fetch('recalls', [])
        end
      end
      
      def recalls
        recalls_raw.map do |recall|
          Hash[fields.map do |field|
            converter = "convert_#{field}"
            value = recall[lookup_field(field)]
            [field, respond_to?(converter) ? send(converter, value) : value ]
          end]
        end
      rescue NoMethodError, TypeError, KeyError => e
        raise MalformedDataError, e
      end
      
      def convert_created_at time
        Time.parse(time) if time
      end

      def convert_updated_at time
        Time.parse(time) if time
      end
    end
  end
end