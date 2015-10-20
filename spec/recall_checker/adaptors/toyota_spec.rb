require 'spec_helper'

describe RecallChecker::Adaptors::Toyota do

  # Don't forget to insert the real key if you need to run these tests without VCR!
  before :each do
    RecallChecker::CaptchaSolver.set_access_key("FAKE_KEY")
  end

  it "loads recall data for VIN 4T1BD1EB1DU003609 with recalls" do
    VCR.use_cassette('toyota_01', :record => :new_episodes) do
      @checker = RecallChecker::Adaptors::Toyota.new("4T1BD1EB1DU003609")
      r = @checker.recalls.first
      expect(r['title']).to start_with "Safety Recall"
      expect(r['created_at']).to eq Date.parse("17 Oct 2013")
      expect(r['nhtsa_id']).to eq "13V442"
      expect(r['manufacturer_id']).to eq "D0T"
      expect(r['description']).to start_with "Toyota is recalling certain model year"
      expect(r['risks']).to eq nil
      expect(r['remedy']).to start_with "Toyota will notify owners"
      expect(r['status']).to eq "Remedy Available"
      expect(r['notes']).to include "https://techinfo.toyota.com/techInfoPortal/staticcontent/en/techinfo/html/prelogin/docs/cp/d0ttofaq.pdf"
    end
  end
  
  it "returns [] for real VIN 4T1BK1EB9DU030210 with no recalls" do
    VCR.use_cassette('toyota_02', :record => :new_episodes) do
      @checker = RecallChecker::Adaptors::Toyota.new("4T1BK1EB9DU030210")
      expect(@checker.recalls).to be_empty
    end
  end

  it "vin_invalid? for other company's VIN WMWXM5C52ET935269" do
    VCR.use_cassette('toyota_03', :record => :new_episodes) do
      @checker = RecallChecker::Adaptors::Toyota.new("WMWXM5C52ET935269")
      expect { @checker.recalls }.to raise_error RecallChecker::VinError
    end
  end

end