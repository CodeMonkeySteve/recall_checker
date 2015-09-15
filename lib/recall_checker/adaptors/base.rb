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

      def model_fields
        [ :title,
          :date, # to be changed to created_at
          :refresh_date, # to be changed to refreshed_at
          :nhtsa_id, 
          :manufacturer_id, 
          :summary, 
          :safety_risk, 
          :remedy, 
          :status, 
          :manufacturer_notes ]
      end

      def new_recall_record
        Hash[model_fields.map { |i| [i, nil] }]
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
      
      # abstractions - redefine them in each particular class!
      def convert_time
        Time.now
      end

      def add_items_to_recalls
      end

      def recalls
        []
      end

      # helpers
      def get_branch hsh, key
        return hsh[key] if hsh.is_a?(Hash) && hsh.has_key?(key) && hsh[key].is_a?(Hash)
      end

    end
  end
end