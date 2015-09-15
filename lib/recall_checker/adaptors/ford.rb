module RecallChecker
  module Adaptors
    class Ford < Base
      make 'ford'
      base_uri 'http://owner.ford.com/sharedServices/recalls/query.do'

      FIELDS = {
        "title" => "description_eng",
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

      def options
        {query: {country: 'USA', language: 'EN', vin: @vin}}
      end


    end
  end
end