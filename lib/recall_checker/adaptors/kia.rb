module RecallChecker
  module Adaptors
    class Kia < Base
      make 'kia'
      base_uri 'http://www.kia.com/us/en/data/owners/recalls/search'

      FIELDS = {
        "title" => "safety_risk_description",
        "created_at" => "recall_date",
        "updated_at" => "refresh_date",
        "nhtsa_id" => "nhtsa_recall_number",
        "manufacturer_id" => "mfr_recall_number",
        "description" => "recall_description",
        "risks" => "safety_risk_description",
        "remedy" => "remedy_description",
        "status" => "recall_status",
        "notes" => "mfr_notes"
      }

      def url
        '/' + @vin
      end

      def recalls_raw
        if parsed_response.has_key?('result') 
          parsed_response.fetch('result', {}).fetch('recallsResult', {}).fetch('recalls', [])
        else
          []
        end
      end

      def convert_created_at time
        Time.at(time[0..9].to_i)
      end

      def convert_updated_at time
        Time.at(time[0..9].to_i)
      end

    end
  end
end