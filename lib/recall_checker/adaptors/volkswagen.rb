module RecallChecker
  module Adaptors
    class Volkswagen < Base
    	make 'volkswagen'
      base_uri 'http://www.vw.com/s2f/vwrecall-nhtsa2/vin'

      def response
        @response ||= self.class.get('/' + @vin)
      end
    end
  end
end