module RecallChecker
  module Adaptors
    class Jaguar < Base
    	make 'jaguar'
      base_uri 'http://www.jaguarusa.com/owners/vin-recall.html'

      def options
        {query: {view: "vinRecallQuery", vin: @vin}}
      end
    end
  end
end