require 'spec_helper'

describe RecallChecker::Adaptors::Hyundai do

  it "loads recall data for VIN 5XYZU3LB6DG036138 with a safety recall" do
    VCR.use_cassette('hyundai_with_recall', :record => :new_episodes) do
      @checker = RecallChecker::Adaptors::Hyundai.new("5XYZU3LB6DG036138")
      expect(@checker.response).not_to be_empty
      expect(@checker.recalls.count).to eq 1

      r = @checker.recalls.first
      expect(r['title']).to start_with "HYUNDAI IS RECALLING CERTAIN MODEL YEAR 2013"
      expect(r['nhtsa_id']).to eq "13V355000"
      expect(r['manufacturer_id']).to eq "112"
      expect(r['created_at']).to eq Date.parse("12 Aug 2013")
      expect(r['description']).to start_with "HYUNDAI IS RECALLING CERTAIN MODEL YEAR 2013"
      expect(r['risks']).to start_with "A FRACTURED FRONT AXLE MAY RESULT IN A LOSS OF POWER"
      expect(r['remedy']).to start_with "HYUNDAI WILL NOTIFY OWNERS"
      expect(r['status']).to eq "RecallINCOMPLETE"
      expect(r['notes']).to eq nil
    end
  end

  it "loads recall data for VIN KMHTC6AD1CU059124 with 2 safety recalls" do
    VCR.use_cassette('hyundai_with_2_recalls', :record => :new_episodes) do
      @checker = RecallChecker::Adaptors::Hyundai.new("KMHTC6AD1CU059124")
      expect(@checker.response).not_to be_empty
      expect(@checker.recalls.count).to eq 2
    end
  end

  it "returns [] for real VIN 5NPE34AF5FH051318 with service campaigns but no safety recalls" do
    VCR.use_cassette('hyundai_with_service_but_no_recalls', :record => :new_episodes) do
      @checker = RecallChecker::Adaptors::Hyundai.new("5NPE34AF5FH051318")
      expect(@checker.recalls).to be_empty
    end
  end

  it "returns [] for real VIN KM8SM4HF1EU042217 with no recalls" do
    VCR.use_cassette('hyundai_no_recalls', :record => :new_episodes) do
      @checker = RecallChecker::Adaptors::Hyundai.new("KM8SM4HF1EU042217")
      expect(@checker.recalls).to be_empty
    end
  end

  it "vin_invalid? for other company's VIN 1N4AL3AP6DN408008" do
    VCR.use_cassette('hyundai_vin_invalid', :record => :new_episodes) do
      @checker = RecallChecker::Adaptors::Hyundai.new("1N4AL3AP6DN408008")
      expect { @checker.recalls }.to raise_error RecallChecker::VinError
    end
  end
end
