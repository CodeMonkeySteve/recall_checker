module RecallChecker
  module Adaptors
    class Volvo < Base
    	make 'Volvo'
      base_uri 'http://www.volvocars.com/us/own/owner-info/recall-information'

      #returns HTML!
    end
  end
end