module RecallChecker
  module Adaptors
    class JaguarLandRover < Base

      FIELDS = {
        "title" => "recallDesc",
        "created_at" => "date",
        "updated_at" => "date",
        "nhtsa_id" => "number",
        "manufacturer_id" => "manufacturerRecallNumber",
        "description" => "recallDesc",
        "risks" => "safetyDescription",
        "remedy" => "repairDesc",
        "status" => "status",
        "notes" => "status"
      }

      def options
        {query: {view: "vinRecallQuery", vin: @vin}}
      end

      def vin_invalid?
        @response.parsed_response.fetch('error',0) == 400
      end

      def recalls_raw
        # Site returns error = 204 if there are no recalls; no error field if recalls exist
        parsed_response.has_key?('error') ? [] : parsed_response['results']
      end

      def convert_created_at time
        DateTime.strptime(time + " " + Time.now.getlocal.zone, "%m/%d/%Y %Z").to_time
      end

      def convert_updated_at time
        convert_created_at time
      end

      def convert_notes notes
        ""
      end

    end

    class Jaguar < JaguarLandRover
      make 'jaguar'
      base_uri 'http://www.jaguarusa.com/owners/vin-recall.html'
    end

    class LandRover < JaguarLandRover
      make 'landrover'
      base_uri 'http://www.landroverusa.com/ownership/product-recall-search.html'
    end

  end
end