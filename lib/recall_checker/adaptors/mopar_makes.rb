module RecallChecker
  module Adaptors
    class MoparMakes < Base
      base_uri 'http://www.moparownerconnect.com/oc/us/en-us/sub/Pages/RecallsResults.aspx'

      #returns HTML!
    end

    class Chrysler < MoparMakes
    	make 'chrysler'
    end

    class Dodge < MoparMakes
    	make 'dodge'
    end

    class Fiat < MoparMakes
    	make 'fiat'
    end

    class Jeep < MoparMakes
    	make 'jeep'
    end

    class AlfaRomeo < MoparMakes
    	make 'alfaromeo'
    end

  end
end