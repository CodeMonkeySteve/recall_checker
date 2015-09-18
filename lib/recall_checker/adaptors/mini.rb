module RecallChecker
  module Adaptors
    class Mini < Base
      make 'mini'
      base_uri 'http://www.miniusa.com/api/safetyRecall.action'

      FIELDS = {
        "title" => "recall_title",
        "created_at" => "recall_date",
        "updated_at" => "refresh_date",
        "nhtsa_id" => "nhtsa_recall_number",
        "manufacturer_id" => "mfr_recall_number",
        "description" => "recall_description",
        "risks" => "safety_risk_description",
        "remedy" => "remedy_description",
        "status" => "mfr_recall_status",
        "notes" => "mfr_notes"
      }

      def vin_invalid?
        !parsed_response['status']
      end

      def convert_status status
        status.to_s
      end

    end
  end
end