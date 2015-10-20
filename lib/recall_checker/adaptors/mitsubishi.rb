module RecallChecker
  module Adaptors
    class Mitsubishi < Base
      make 'mitsubishi'
      base_uri 'http://www.mitsubishicars.com/rs/warranty'

      FIELDS = {
        "title" => "recallDescription",
        "created_at" => "recallDate",
        "updated_at" => "recallDate",
        "nhtsa_id" => "nhtsaRecallNumber",
        "manufacturer_id" => "mfrRecallNumber",
        "description" => "recallDescription",
        "risks" => "safetyRiskDescription",
        "remedy" => "remedyDescription",
        "status" => "mfrRecallStatus"
      }

      def vin_invalid?
        !@response.parsed_response['success']
      end

      def recalls_raw
        response.parsed_response['nhtsaOpenRecalls'].select { |i| i['recallType'] == "SAFETY RECALL" }
      end

      def convert_nhtsa_id id
        id.strip
      end

      def convert_manufacturer_id id
        id.strip
      end

      def convert_status str
        "Recall status information is not available"
      end

      def convert_updated_at date
        Date.parse(parsed_response['nhtsaVehicle']['recallRefreshDate'])
      end

    end
  end
end