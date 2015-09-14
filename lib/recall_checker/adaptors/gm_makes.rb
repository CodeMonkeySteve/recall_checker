module RecallChecker
  module Adaptors
    class GMMakes < Base
      base_uri 'http://recalls.gm.com/recall/services'

      def response
        @response ||= self.class.get('/' + @vin + '/recalls')
      end
    end

    class Chevrolet < GMMakes
    	make 'chevrolet'
    end

    class GMC < GMMakes
    	make 'gmc'
    end

    class Cadillac < GMMakes
    	make 'cadillac'
    end

    class Pontiac < GMMakes
    	make 'pontiac'
    end

    class Oldsmobile < GMMakes
    	make 'oldsmobile'
    end

    class Saturn < GMMakes
    	make 'saturn'
    end

    class Hummer < GMMakes
    	make 'hummer'
    end

  end
end