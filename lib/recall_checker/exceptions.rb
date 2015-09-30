module RecallChecker

  class Error < StandardError; end
  class CaptchaSolverError < Error; end

  # Raised when the supplied VIN is invalid
  class VinError < Error; end

  # Raised for server connection errors
  class ConnectionError < Error; end  

  # Raised if the data returned from the server cannot be parsed properly
  class MalformedDataError < Error; end  

  # Captcha request was not sent before executing the main request
  class CaptchaNotRequestedError < Error; end

  # No captcha answer supplied to the class that requires it
  class CaptchaNotSolvedError < Error; end


  # No credits on the decaptcha service balance
  class CaptchaZeroBalanceError < CaptchaSolverError; end
  
  # Cannot connect to the decaptcha service
  class CaptchaConnectionError < CaptchaSolverError; end

end