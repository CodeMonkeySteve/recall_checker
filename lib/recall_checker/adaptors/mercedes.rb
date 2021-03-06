module RecallChecker
  module Adaptors
    class MercedesMakes < Base
      base_uri 'http://www.mbusa.com/mercedes'

      FIELDS = {
        "title" => "component",
        "created_at" => "recallDate",
        "updated_at" => "refreshDate",
        "nhtsa_id" => "nhtsaRecallNumber",
        "manufacturer_id" => "mbusaId",
        "description" => "recallDescription",
        "risks" => "safetyRiskDescription",
        "remedy" => "remedyDescription",
        "status" => "mfrRecallStatusDesc"
      }

      def request
        page = self.class.get("/recall")
        headers = { 'Cookie' => page.headers['Set-Cookie'] }
        body = { 'CSRF_TOKEN' => Nokogiri::HTML(page).css('#CSRF_TOKEN').attr('value').text, 'vin' => @vin }
        self.class.post("/json/recall/campaigns", headers: headers, body: body)
      end

      def vin_invalid?
        @response.parsed_response["page"]["recallCampaign"]["status"] == "vinError"
      end

      def recalls_raw
        parsed_response["page"]["recallCampaign"]["recalls"]
      end

      def convert_updated_at date
        Date.parse(date) unless date.empty?
      end

    end

    # commented out to use Recallmasters instead
    
    class MercedesBenz < MercedesMakes
      # make 'mercedesbenz'
    end

    class Maybach < MercedesMakes
      # make 'maybach'
    end
  end
end

