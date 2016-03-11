module RecallChecker
  module Adaptors
    class Base
      include HTTParty

      @@adaptors = {}
      FIELDS = {}

      FALLBACK_ADAPTOR = 'recallmasters'

      class << self
        def make make
          @@adaptors[make] = self
        end
      
        def find_by_make_and_vin make, vin
          (@@adaptors[normalize(make)] || @@adaptors[FALLBACK_ADAPTOR]).new(vin)
        end

        def supported? make
          @@adaptors.include? normalize(make)
        end
        
        private
        def normalize make
          make.downcase.tr('^a-z0-9', '')
        end
      end

      def initialize vin
        @vin = vin.upcase
        raise VinError, "Invalid VIN format: #{vin}" if !VINValidator.format_valid?(@vin)
        raise VinError, "Invalid check digit in the VIN: #{vin}" if !VINValidator.check_digit_valid?(@vin)
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

      def response_empty?
        @response.parsed_response.nil? || @response.parsed_response.empty?
      end

      def response_not_ok?
        !@response.response.is_a?(Net::HTTPOK)
      end

      def server_error_msg
      end

      def response
        @response ||= request
        raise ServiceError, "The server returned an empty response" if response_empty?
        raise ServiceError, "The server returned status #{@response.code}" if response_not_ok?
        raise VinError, server_error_msg || "VIN is not recognized by the manufacturer: #{@vin}" if vin_invalid?
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
      
      def convert_created_at date
        date ? Date.parse(date) : Time.now.to_date
      end

      def convert_updated_at date
        date ? Date.parse(date) : Time.now.to_date
      end
    end
  end
end