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
        "status" => "RecallStatus",
        "notes" => "RecallStatus"
      }

      def url
        "/#{@vin}/true" 
      end

      def invalid_vin?
        response['Warning']
      end

      def recalls_raw
        invalid_vin? ? [] : parsed_response['CampaignTypes'].first['Campaigns'] or []
      end

      def convert_notes str
        "" 
      end

      def convert_created_at time
        DateTime.strptime(time + " " + Time.now.getlocal.zone, "%m/%d/%Y %Z").to_time
      end

      def convert_updated_at time
        t = response.fetch("LastUpdated", "")
        !t.empty? ? Time.parse(t) : convert_created_at(time)
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