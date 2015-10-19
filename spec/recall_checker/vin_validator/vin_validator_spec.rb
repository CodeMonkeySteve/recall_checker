require 'spec_helper'

describe RecallChecker::VINValidator do

  it "validates VIN format" do
    vv = RecallChecker::VINValidator
    expect(vv.format_valid?("1234")).to eq false
    expect(vv.format_valid?("THISISAVIN")).to eq false
    expect(vv.format_valid?("WMWXM5C5IET935269")).to eq false
    expect(vv.format_valid?("1N4AL3AP6 DN408008")).to eq false
    expect(vv.format_valid?("11111111111111111")).to eq true
    expect(vv.format_valid?("4A4AP5AU3DE022512")).to eq true
  end

  it "validates check digit" do
    vv = RecallChecker::VINValidator
    expect(vv.check_digit_valid?("11111111111111111")).to eq true
    expect(vv.check_digit_valid?("11111111111111112")).to eq false
    expect(vv.check_digit_valid?("WMWXM5C52ET935269")).to eq true
    expect(vv.check_digit_valid?("WMWXM5C54ET935269")).to eq false
  end

  it "validates all at once" do
    vv = RecallChecker::VINValidator
    expect(vv.vin_valid?("THISISAVIN")).to eq false
    expect(vv.vin_valid?("11111111111111111")).to eq true
  end

end