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
        "remedy" => "remedyDescription",
        "status" => "typeCode", # status not available in JSON
        "notes" => "typeCode" # notes not available in JSON
      }

      def vin_invalid?
        @response.parsed_response['make'].empty?
      end

      def convert_created_at time
        Time.parse(time[0..9] + " " + time[11..18])
      end

      def convert_updated_at time
        Time.parse(time[0..9] + " " + time[11..18])
      end

      def convert_status str
        "Recall status information is not available"
      end

      def convert_notes str
        "Type code: #{str}" 
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