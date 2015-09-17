module RecallChecker
  module Adaptors
    class BMW < Base
      make 'bmw'
      base_uri 'http://www.bmwusa.com/Services/VinRecallService.svc/GetRecallCampaignsForVin'

      FIELDS = {
        "title" => "Title",
        "created_at" => "RecallDate",
        "updated_at" => "RefreshDate",
        "nhtsa_id" => "RecallNumber",
        "manufacturer_id" => "ManufacturerRecallNumber",
        "description" => "Description",
        "risks" => "SafetyRiskDescription",
        "remedy" => "RemedyDescription",
        "status" => "ManufacturerRecallStatus",
        "notes" => "ManufacturerNotes"
      }

      def url
        '/' + @vin
      end

      def invalid_vin?
        parsed_response['ViewModel']['Error'] > 0
      end

      def recalls_raw
        invalid_vin? ? [] : parsed_response['ViewModel']['RecallCampaigns']
      end

      def convert_status status
        status.to_s # The site only returns a numeric status code
      end

    end
  end
end