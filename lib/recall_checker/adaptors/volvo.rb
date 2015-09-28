module RecallChecker
  module Adaptors
    class Volvo < Base
      make 'Volvo'
      base_uri 'http://www.volvocars.com/us/own/owner-info/recall-information'

      FIELDS = {
        "title" => "Recall Info",
        "created_at" => "Recall Date",
        "nhtsa_id" => "NHTSA Recall Number",
        "manufacturer_id" => "Manufacturer Recall Number",
        "description" => "Recall Info",
        "risks" => "Safety Risk",
        "remedy" => "Remedy",
        "status" => "Recall Status",
        "notes" => "Notes"
      }

      def vin_invalid?
        @response.parsed_response.include? "VIN is not valid"
      end

      def htmlpage
        @htmlpage ||= Nokogiri::HTML(parsed_response)
      end

      def recalls_raw
        no_of_recalls = htmlpage.css("div.recall-list-wrapper div.sub-header").text.split(":")[1].to_i
        html_recalls = htmlpage.css('ul.recall-list li.recall-item ul.recall-item-info').to_a
        if html_recalls.empty?
          Array.new(no_of_recalls, {})
        else
          html_recalls.map do |recall|
            names = recall.css('div.left').to_a.map { |x| x.text }
            values = recall.css('div.right').to_a.map { |x| x.text }
            Hash[names.zip values]
          end
        end
      end

    end
  end
end