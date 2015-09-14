module RecallChecker
  module Adaptors
    class Nissan < Base
      make 'nissan'
      base_uri 'http://www.nissanusa.com/dealercenter/api/recalls'
    end
  end
end