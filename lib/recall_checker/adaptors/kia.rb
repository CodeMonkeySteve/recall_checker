module RecallChecker
  module Adaptors
    class Kia < Base
      make 'kia'
      base_uri 'http://www.kia.com/us/en/data/owners/recalls/search'

      def response
        @response ||= self.class.get('/'+@vin)
      end
    end
  end
end