module RecallChecker

  class Error < StandardError; end
  class CaptchaSolverError < Error; end

  # Raised when the supplied make is not supported by this library
  class MakeError < Error; end

  # Raised when the supplied VIN is invalid
  class VinError < Error; end

  # Raised for server connection errors
  class ConnectionError < Error; end  

  # Raised if the data returned from the server cannot be parsed properly
  class MalformedDataError < Error; end  

  # Raised when the server returns an empty response
  class ServiceError < Error; end

  # Captcha request was not sent before executing the main request
  class CaptchaNotRequestedError < Error; end

  # No captcha answer supplied to the class that requires it
  class CaptchaNotSolvedError < Error; end


  # No credits on the decaptcha service balance
  class CaptchaZeroBalanceError < CaptchaSolverError; end
  
  # Cannot connect to the decaptcha service
  class CaptchaConnectionError < CaptchaSolverError; end

  # Too many failed attempts to solve captcha
  class CaptchaTooManyFailuresError < CaptchaSolverError; end

end