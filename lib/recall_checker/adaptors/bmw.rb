module RecallChecker
  module Adaptors
    class BMW < Base
      make 'bmw'
      base_uri 'http://www.bmwusa.com/Services/VinRecallService.svc/GetRecallCampaignsForVin'

      def response
        @response ||= self.class.get('/'+@vin)
      end
    end
  end
end