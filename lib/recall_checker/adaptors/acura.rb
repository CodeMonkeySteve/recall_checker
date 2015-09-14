module RecallChecker
  module Adaptors
    class Acura < Base
      make 'acura'
      base_uri 'http://owners.acura.com/Recalls/GetRecallsByVin'

      def response
        @response ||= self.class.get('/'+@vin+'/true')
      end
    end
  end
end