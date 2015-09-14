module RecallChecker
  module Adaptors
    class Honda < Base
      make 'honda'
      base_uri 'http://owners.honda.com/Recalls/GetRecallsByVin'

      def response
        @response ||= self.class.get('/'+@vin+'/true')
      end
    end
  end
end