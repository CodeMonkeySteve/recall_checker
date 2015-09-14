module RecallChecker
  module Adaptors
    class Porsche < Base
    	make 'porsche'
      base_uri 'http://recall.porsche.com/prod/pag/vinrecalllookup.nsf/GetVINResult'

      def options
        {query: {openagent: "", fin: @vin, language: "us"}}
      end

      #returns HTML page!
    end
  end
end