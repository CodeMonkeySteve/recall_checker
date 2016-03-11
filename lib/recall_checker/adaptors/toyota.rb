module RecallChecker
  module Adaptors
    class ToyotaMakes < Base
      base_uri 'http://www.toyota.com'

      attr_reader :captcha_image, :captcha_key
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
        @captcha_image = page.parsed_response['captcha']['captcha']
        @captcha_key = page.parsed_response['captcha']['key']
        @captcha_image
      end

      def url
        raise CaptchaNotRequestedError if !@captcha_key
        raise CaptchaNotSolvedError if !@captcha_answer
        "/SSCLookupApp/sscl/getSSC/" + @vin + "/" + @captcha_key + "/" + @captcha_answer + "?lang=en"
      end

      def request
        @captcha = CaptchaSolver.new(request_captcha)
        @captcha_answer = @captcha.solve
        self.class.get(url, headers: @headers)
      end

      def response
        attempts = 0
        begin
          @response = nil
          attempts += 1
          raise CaptchaTooManyFailuresError, "Too many failed attempts to solve the captcha" if attempts > 3
          super
          @captcha.request_refund if captcha_error?
        end until !captcha_error?
        @response
      end

      def vin_invalid?
        @response.parsed_response['status'] == "NOT_FOUND" 
      end

      def captcha_error?
        @response.parsed_response['status'] == "INVALID"
      end

      def recalls_raw
        parsed_response['sscviewModels'].select { |x| x['recall'] }
      end

      def convert_created_at date
        Date.parse(date)
      end

      def convert_updated_at date
        convert_created_at date
      end

    end

    # commented out to use Recallmasters instead

    class Toyota < ToyotaMakes
      # make 'toyota'
    end

    class Lexus < ToyotaMakes
      # make 'lexus'
    end

    class Scion < ToyotaMakes
      # make 'scion'
    end

  end
end