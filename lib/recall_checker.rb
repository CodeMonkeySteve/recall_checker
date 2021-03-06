require "httparty"
require "nokogiri"
require "active_support"
require "recall_checker/captcha_solver/captcha_solver"
require "recall_checker/nhtsa_feed/nhtsa_feed"
require "recall_checker/vin_validator/vin_validator"
require "recall_checker/version"
require "recall_checker/exceptions"
require "recall_checker/adaptors/base.rb"
Dir[File.dirname(__FILE__) + '/recall_checker/adaptors/*.rb'].each { |file| require file }

module RecallChecker
  extend SingleForwardable
  def_delegator "RecallChecker::Adaptors::Base", :find_by_make_and_vin
  def_delegator "RecallChecker::Adaptors::Base", :supported?
end
