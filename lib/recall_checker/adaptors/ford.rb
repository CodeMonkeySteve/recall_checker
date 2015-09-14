module RecallChecker
  module Adaptors
    class Ford < Base
    	make 'ford'
      base_uri 'http://owner.ford.com/sharedServices/decodevin.do'

    end
  end
end