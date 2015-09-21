module RecallChecker
  module Adaptors
    class Smart < Base
      make 'smart'
      base_uri 'http://www.smartusa.com/getrecallsjson'

      FIELDS = {
        "title" => "component",
        "created_at" => "recallDate",
        "updated_at" => "recallDate",
        "nhtsa_id" => "nhtsaRecallNumber",
        "manufacturer_id" => "mbusaId",
        "description" => "recallDescription",
        "risks" => "safetyRiskDescription",
        "remedy" => "remedyDescription",
        "status" => "mfrRecallStatusDesc",
        "notes" => "status"
      }

      def url
        '/' + @vin
      end

      def vin_invalid?
        JSON.parse(@response.parsed_response)['page']['recallCampaign']['status'] == "vinError"
      end

      def recalls_raw
        JSON.parse(parsed_response)['page']['recallCampaign']['recalls']
      end

      def convert_notes notes
        ""
      end

    end
  end
end