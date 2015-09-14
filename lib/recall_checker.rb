require "httparty"
require "recall_checker/version"
Dir[File.dirname(__FILE__) + '/recall_checker/adaptors/*.rb'].each { |file| require file }

module RecallChecker
  extend SingleForwardable
  def_delegator "RecallChecker::Adaptors::Base", :find_by_make_and_vin  
end
