module RecallChecker
  module Adaptors
    class FordMakes < Base
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

      def vin_invalid?
        @response.parsed_response['return_status']['code'].to_i == 1
      end

      def recalls_raw
        r = parsed_response.has_key?('recalls') ? parsed_response['recalls']['nhtsa_recall_item'] : []
        r.is_a?(Array) ? r : [r]
      end

    end

    class Ford < FordMakes
      make 'ford'
    end

    class Lincoln < FordMakes
      make 'lincoln'
    end

    class Mercury < FordMakes
      make 'mercury'
    end
  end
end