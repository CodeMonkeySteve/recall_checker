module RecallChecker
  module Adaptors
    class Audi < Base
      make 'audi'
      base_uri 'http://web.audiusa.com/audirecall/vin'

      FIELDS = {
        "title" => "vwgoaActionTitle",
        "created_at" => "recallDate",
        "updated_at" => "refreshDate",
        "nhtsa_id" => "nhtsaRecallNumber",
        "manufacturer_id" => "mfrRecallNumber",
        "description" => "recallDescription",
        "risks" => "safetyRiskDescription",
        "remedy" => "remedyDescription",
        "status" => "mfrRecallStatus",
        "notes" => "mfrNotes"
      }

      def url
        "/#{@vin}"
      end

      def vin_invalid?
        !parsed_response['status']
      end

      def convert_status status
        status.to_s
      end

    end
  end
end