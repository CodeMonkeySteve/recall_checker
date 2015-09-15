module RecallChecker
  module Adaptors
    class Infiniti < Base
      make 'infiniti'
      base_uri 'http://www.infinitiusa.com/dealercenter/api/recalls'

      def add_items_to_recalls key
        if parsed_response.is_a?(Hash) && parsed_response.has_key?(key)
          parsed_response[key].each do |i| 
            i.each do |k,v|
              @recalls << v["primaryDescription"] if v.is_a?(Hash) && v.has_key?("primaryDescription")
            end
          end
        end
      end

      def recalls
        if @recalls.nil?
          @recalls = []
          add_items_to_recalls "recalls"
        end
        return @recalls
      end

    end
  end
end