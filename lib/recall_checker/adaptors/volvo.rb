module RecallChecker
  module Adaptors
    class Volvo < Base
    	make 'Volvo'
      base_uri 'http://www.volvocars.com/us/own/owner-info/recall-information'

      def vin_invalid?
      	@response.parsed_response.include? "VIN is not valid"
      end

      def htmlpage
        @htmlpage ||= Nokogiri::HTML(parsed_response)
      end

      def recalls_raw
      	no_of_recalls = htmlpage.css("div.recall-list-wrapper div.sub-header").text.split(":")[1].to_i
      	Array.new(no_of_recalls, {}) # we will stick to this until we find Volvo VINs with detailed recall info
      end

      def convert_created_at time
      end

      def convert_updated_at time
      end

    end
  end
end