module RecallChecker
  module Adaptors
    class Smart < Base
    	make 'smart'
      base_uri 'http://www.smartusa.com/service.svx/recall/campaigns'

      def response
        @response ||= self.class.post("", options)
      end

    end
  end
end