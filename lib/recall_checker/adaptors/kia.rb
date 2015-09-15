module RecallChecker
  module Adaptors
    class Kia < Base
      make 'kia'
      # base_uri 'http://www.kia.com/us/en/data/owners/recalls/search'
      base_uri 'http://localhost:30000'

      def url
      	'/' + @vin
      end

    end
  end
end