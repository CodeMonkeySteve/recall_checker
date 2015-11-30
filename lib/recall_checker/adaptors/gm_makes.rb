module RecallChecker
  module Adaptors
    class GMMakes < Base
      base_uri 'http://recalls.gm.com/recall/services'

      FIELDS = {
        "title" => "recall_title",
        "created_at" => "recall_date",
        "updated_at" => "recall_date",
        "nhtsa_id" => "nhtsa_recall_number",
        "manufacturer_id" => "mfr_recall_number",
        "description" => "recall_description",
        "risks" => "safety_risk_description",
        "remedy" => "remedy_description",
        "status" => "mfr_recall_status"
      }

      def url
        "/#{@vin}/recalls"
      end

      def response_not_ok? r
        !(r.response.is_a?(Net::HTTPOK) || r.response.is_a?(Net::HTTPBadRequest))
      end

      def vin_invalid?
        @response.parsed_response['data'].nil?
      end

      def recalls_raw
        parsed_response['data']['recalls']
      end

      def convert_updated_at time
        Date.parse(parsed_response['data']['refresh_date'])
      end

    end

    class Buick < GMMakes
      make 'buick'
    end

    class Chevrolet < GMMakes
      make 'chevrolet'
    end

    class GMC < GMMakes
      make 'gmc'
    end

    class Cadillac < GMMakes
      make 'cadillac'
    end

    class Pontiac < GMMakes
      make 'pontiac'
    end

    class Oldsmobile < GMMakes
      make 'oldsmobile'
    end

    class Saturn < GMMakes
      make 'saturn'
    end

    class Hummer < GMMakes
      make 'hummer'
    end

    class Saab < GMMakes
      make 'saab'
    end

  end
end