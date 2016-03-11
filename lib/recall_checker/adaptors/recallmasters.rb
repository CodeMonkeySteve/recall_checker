# Before instantiating the adaptor, set the access key provided by Recallmasters:
# RecallChecker::Adaptors::Recallmasters.set_access_key("KEY_GOES_HERE")
module RecallChecker
  module Adaptors
    class Recallmasters < Base
      make 'recallmasters'
      base_uri 'https://app.recallmasters.com/api/v1/lookup'

      FIELDS = {
        "title" => "name",
        "created_at" => "effective_date",
        "nhtsa_id" => "nhtsa_id",
        "manufacturer_id" => "oem_id",
        "description" => "description",
        "risks" => "risk",
        "remedy" => "remedy"
      }

      def self.set_access_key key
        @@access_key = key
      end

      def url
        "/#{@vin}/?format=json" 
      end

      def options
        { headers: { "Authorization" => "Token #{@@access_key}" } }
      end

      def response_not_ok?
        !([Net::HTTPOK, Net::HTTPBadRequest, Net::HTTPUnauthorized].include? @response.response.class)
      end

      def server_error_msg
        error = @response.parsed_response['error_description']
        detail = @response.parsed_response['detail']
        "Server returned error: #{error} #{detail}" if error || detail 
      end

      def vin_invalid?
        !@response.response.is_a?(Net::HTTPOK)
      end

    end
  end
end