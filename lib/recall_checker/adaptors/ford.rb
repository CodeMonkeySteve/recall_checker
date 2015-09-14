module RecallChecker
  module Adaptors
    class Ford < Base
      make 'ford'
      # base_uri 'http://owner.ford.com/sharedServices/decodevin.do'
      base_uri 'http://owner.ford.com/sharedServices/recalls/query.do'

      def options
        {query: {country: 'USA', language: 'EN', vin: @vin}}
      end

      def add_items_to_recalls key
        if parsed.response.is_a?(Hash) && parsed_response.has_key?(key)
          parsed_response[key].each do |k,v| 
            @recalls << v["description_eng"] if v.is_a?(Hash) && v.has_key?("description_eng")
          end
        end
      end

      def recalls
        if @recalls.nil?
          @recalls = []
          add_items_to_recalls "recalls"
          add_items_to_recalls "fsa_items"
        end
        return @recalls
      end

    end
  end
end