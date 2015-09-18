module RecallChecker
  module Adaptors
    class VWMakes < Base

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

    class Audi < VWMakes
      make 'audi'
      base_uri 'http://web.audiusa.com/audirecall/vin'
    end

    class Volkswagen < VWMakes
      make 'volkswagen'
      base_uri 'http://www.vw.com/s2f/vwrecall-nhtsa2/vin'
    end
  end
end