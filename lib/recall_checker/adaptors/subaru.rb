module RecallChecker
  module Adaptors
    class Subaru < Base
      make 'subaru'
      base_uri 'http://www.subaru.com/services/vehicles/recalls'
      
      FIELDS = {
        "title" => "shortDescription",
        "created_at" => "date",
        "updated_at" => "lastModified",
        "nhtsa_id" => "nhtsaRecallNumber",
        "manufacturer_id" => "code",
        "description" => "description",
        "risks" => "safetyRiskDescription",
        "remedy" => "remedyDescription",
        "status" => "status",
        "notes" => "recallLetter"
      }

      def response_not_ok? r
        !(r.response.is_a?(Net::HTTPOK) || r.response.is_a?(Net::HTTPNotFound))
      end

      def vin_invalid?
        @response.response.is_a?(Net::HTTPNotFound)
      end

      def recalls_raw
        r = parsed_response['recalls']
        r.select { |i| i.fetch('type',"") == "Safety" && i.fetch('status',"") == "Open" }
      end

      def convert_created_at date
        Date.parse(date["fullDate"])
      end

      def convert_updated_at date
        convert_created_at date
      end

      def convert_notes notes
        Nokogiri::HTML(notes).text
      end

    end
  end
end