module RecallChecker

  class Error < StandardError; end

  # Raised when the supplied VIN is invalid
  class VinError < Error; end

  # Raised for server connection errors
  class ConnectionError < Error; end  

  # Raised if the data returned from the server cannot be parsed properly
  class MalformedDataError < Error; end  
end