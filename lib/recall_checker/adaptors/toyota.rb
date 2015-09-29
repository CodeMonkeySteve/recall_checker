module RecallChecker
  module Adaptors
    class Toyota < Base
      make 'toyota'
      base_uri 'http://www.toyota.com'

      attr_reader :captcha_image_src, :captcha_key
      attr_accessor :captcha_answer

      FIELDS = {
        "title" => "title",
        "created_at" => "recallDate",
        "updated_at" => "lastUpdated",
        "nhtsa_id" => "nhtsareferenceId",
        "manufacturer_id" => "dealerReferenceId",
        "description" => "description",
        "status" => "sscStatus",
        "notes" => "faq"
      }

      def captcha_url
        '/SSCLookupApp/sscl/pageLoad?lang=en'
      end

      def request_captcha
        page = self.class.get(captcha_url)
        @headers = { 'Cookie' => page.headers['Set-Cookie'] }
        @captcha_image_src = 'data:image/png;base64, ' + page.parsed_response['captcha']['captcha']
        @captcha_key = page.parsed_response['captcha']['key']
        @captcha_image_src
      end

      def url
        raise CaptchaNotRequestedError if !@captcha_key
        raise CaptchaNotSolvedError if !@captcha_answer
        "/SSCLookupApp/sscl/getSSC/" + @vin + "/" + @captcha_key + "/" + @captcha_answer + "?lang=en"
      end

      def request
        self.class.get(url, headers: @headers)
      end

      def vin_invalid?
        @response.parsed_response['status'] == "NOT_FOUND" || !@response.parsed_response['success']
      end

      def captcha_error?
        @response.parsed_response['status'] == "INVALID"
      end

      def recalls_raw
        parsed_response['sscviewModels'].select { |x| x['recall'] }
      end

      def convert_created_at time
        Time.parse(time[0..9])
      end

      def convert_updated_at time
        Time.parse(time[0..9])
      end

    end
  end
end