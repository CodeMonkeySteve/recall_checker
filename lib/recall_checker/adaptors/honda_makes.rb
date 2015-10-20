module RecallChecker
  module Adaptors
    class HondaMakes < Base

      FIELDS = {
        "title" => "Description",
        "created_at" => "RecallDate",
        "updated_at" => "RecallDate",
        "nhtsa_id" => "RecallNumber",
        "manufacturer_id" => "Id",
        "description" => "RecallDescription",
        "risks" => "SafetyRiskDescription",
        "remedy" => "RemedyDescription",
        "status" => "RecallStatus"
      }

      def url
        "/#{@vin}/true" 
      end

      def vin_invalid?
        @response.parsed_response['Warning']
      end

      def recalls_raw
        parsed_response['CampaignTypes'].first['Campaigns'] or []
      end

      def convert_created_at date
        Date.strptime(date, '%m/%d/%Y')
      end

      def convert_updated_at date
        Date.parse(parsed_response["LastUpdated"])
      end

    end

    class Honda < HondaMakes
      make 'honda'
      base_uri 'http://owners.honda.com/Recalls/GetRecallsByVin'
    end

    class Acura < HondaMakes
      make 'acura'
      base_uri 'http://owners.acura.com/Recalls/GetRecallsByVin'
    end

  end
end