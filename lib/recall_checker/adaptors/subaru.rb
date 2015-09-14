module RecallChecker
  module Adaptors
    class Subaru < Base
    	make 'subaru'
      base_uri 'http://www.subaru.com/services/vehicles/recalls'

      #returns HTML!
    end
  end
end