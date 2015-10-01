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
        "status" => "mfrRecallStatusDesc"
      }

      def url
        '/' + @vin
      end

      def vin_invalid?
        r = @response.parsed_response
        raise MalformedDataError, "The server returned empty answer" if r.nil?
        JSON.parse(r)['page']['recallCampaign']['status'] == "vinError"
      end

      def recalls_raw
        JSON.parse(parsed_response)['page']['recallCampaign']['recalls']
      end

    end
  end
end