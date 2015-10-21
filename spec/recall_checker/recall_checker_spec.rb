require 'spec_helper'

describe RecallChecker, "exposed methods" do
  it "check supported for various types of spelling" do
    expect(RecallChecker).not_to be_supported 'some shit'
    expect(RecallChecker).to be_supported 'Mercedes Benz'
    expect(RecallChecker).to be_supported 'mercedes-benz'
    expect(RecallChecker).to be_supported 'LandRover'
    expect(RecallChecker).to be_supported 'Land Rover'
  end
end