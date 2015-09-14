module RecallChecker
  module Adaptors
    class LandRover < Base
    	make 'landrover'
      base_uri 'http://www.landroverusa.com/ownership/product-recall-search.html'

      def options
        {query: {view: "vinRecallQuery", vin: @vin}}
      end
    end
  end
end