require 'spec_helper'

describe RecallChecker, "exposed methods" do
  it "check supported for various types of spelling" do
    expect(RecallChecker).not_to be_supported 'some shit'
    expect(RecallChecker).to be_supported 'landrover'
    expect(RecallChecker).to be_supported 'Land-Rover'
    expect(RecallChecker).to be_supported 'Land_Rover'
    expect(RecallChecker).to be_supported 'Land Rover'
  end
end