module RecallChecker
  module Adaptors
    class NissanMakes < Base

      FIELDS = {
        "title" => "secondaryDescription",
        "created_at" => "effectiveDate",
        "updated_at" => "effectiveDate", # update date not available in JSON
        "nhtsa_id" => "nhtsaId",
        "manufacturer_id" => "nnaId",
        "description" => "primaryDescription",
        "risks" => "riskIfNotRepaired",
        "remedy" => "remedyDescription"
      }

      def vin_invalid?
        @response.parsed_response['make'].empty?
      end

      def recalls_raw
        parsed_response.fetch('recalls', []).select { |x| x['typeCode'] == "Recall Campaign" }
      end

      def convert_created_at time
        Time.parse(time[0..9] + " " + time[11..18])
      end

      def convert_updated_at time
        Time.parse(time[0..9] + " " + time[11..18])
      end

    end

    class Infiniti < NissanMakes
      make 'infiniti'
      base_uri 'http://www.infinitiusa.com/dealercenter/api/recalls'
    end

    class Nissan < NissanMakes
      make 'nissan'
      base_uri 'http://www.nissanusa.com/dealercenter/api/recalls'
    end
  end
end