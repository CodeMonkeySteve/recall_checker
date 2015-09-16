module RecallChecker
  module Adaptors
    class Acura < Base
      make 'acura'
      base_uri 'http://owners.acura.com/Recalls/GetRecallsByVin'

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

      def recalls_raw
        p = parsed_response.fetch('CampaignTypes', []) # CampaignTypes is nil for invalid VINs
        c = (p && !p.empty? ? p.first.fetch("Campaigns", []) : []) # Campaigns is nil for VINs with no recalls
        c && !c.empty? ? c : []
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
  end
end