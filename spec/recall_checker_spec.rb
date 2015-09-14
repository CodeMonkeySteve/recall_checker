require 'spec_helper'

describe RecallChecker do
  it "should register adaptors automatically" do
    p RecallChecker::TR
    # p RecallChecker.adaptors
    # p RecallChecker::Adaptors::Nissan
  end
end