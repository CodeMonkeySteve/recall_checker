module RecallChecker
  module Adaptors
    class Subaru < Base
    	make 'subaru'
      base_uri 'http://www.volvocars.com/us/own/owner-info/recall-information'

      #returns HTML!
    end
  end
end