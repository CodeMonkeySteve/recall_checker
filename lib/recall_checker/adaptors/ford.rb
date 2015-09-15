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

      def recalls_raw
        parsed_response.has_key?('recalls') ? parsed_response['recalls'].values : []
      end

#      def lookup_field field
#        FIELDS.fetch(field, field)
        # f = FIELDS.fetch(field, field)
        # puts "lookup_field: #{field} - #{f}"
        # return f
#      end


    end
  end
end