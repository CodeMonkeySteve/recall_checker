# Captcha solver API for expertdecoders.com
# Before creating a new object, set the service access key:
# RecallChecker::CaptchaSolver.set_access_key("...")

require 'httparty'
require 'securerandom'

module RecallChecker
  class CaptchaSolver
    include HTTParty
    base_uri "http://www.fasttypers.org/imagepost.ashx"

    attr_reader :image_base64, :access_key, :task_id

    # Set the access key provided by the service
    def self.set_access_key key
      @@access_key = key
    end

    # Supply the captcha image as the base64-encoded string
    def initialize image_base64
      @image_base64 = image_base64
      @task_id ||= SecureRandom.random_number(1000000000)
    end

    # Returns the captcha solution string
    def solve
      # Balance checking is temporarily disabled because ExpertDecoders has problems with it
      # raise CaptchaZeroBalanceError, "No credits left on your decaptcha service balance" if balance < 1
      body = { action: "upload", key: @@access_key, gen_task_id: @task_id, file: @image_base64 }
      post_request(body).chomp
    end

    # Returns the remaining number of credits on your account
    def balance
      body = { action: "balance", key: @@access_key }
      post_request(body).to_i
    end

    # Call this if the captcha was solved incorrectly
    def request_refund
      body = { action: "refund", key: @@access_key, gen_task_id: @task_id }
      post_request(body)
    end

    private
    def post_request body
      r = self.class.post("", body: body)
      raise CaptchaSolverError, r if r =~ /\AError/
      r
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ETIMEDOUT => e
      raise CaptchaConnectionError, e
    end
  end
end
