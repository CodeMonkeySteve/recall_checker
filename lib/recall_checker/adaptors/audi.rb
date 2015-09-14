module RecallChecker
  module Adaptors
    class Audi < Base
      make 'audi'
      base_uri 'http://web.audiusa.com/audirecall/vin'

      def response
        @response ||= self.class.get('/'+@vin)
      end
    end
  end
end