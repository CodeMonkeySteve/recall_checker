require 'spec_helper'

describe RecallChecker::Adaptors::Hyundai do

    it "the tests are currently bypassed because VCR cannot be used in this case" do
      # Uncomment the following tests if it's needed.
      # VCR is disabled here because all pages are redirected to the same URL,
      # therefore VCR loads same data for different cases
      true
    end

=begin
    it "loads recall data for VIN 5XYZU3LB6DG036138 with a safety recall" do
      # VCR.use_cassette('hyundai', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Hyundai.new("5XYZU3LB6DG036138")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to start_with "SANTA FE SPORT AXLE"
        expect(r['nhtsa_id']).to eq nil
        expect(r['manufacturer_id']).to eq "112"
        expect(r['description']).to eq nil
        expect(r['risks']).to eq nil
        expect(r['remedy']).to eq nil
        expect(r['status']).to eq nil
        expect(r['notes']).to eq nil
      # end
    end

    it "loads recall data for VIN KMHTC6AD1CU059124 with 2 safety recalls" do
      # VCR.use_cassette('hyundai', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Hyundai.new("KMHTC6AD1CU059124")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 2
      # end
    end

    it "returns [] for real VIN 5NPE34AF5FH051318 with service campaigns but no safety recalls" do
      # VCR.use_cassette('hyundai', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Hyundai.new("5NPE34AF5FH051318")
        expect(@checker.recalls).to be_empty
      # end
    end

    it "returns [] for real VIN KM8SM4HF1EU042217 with no recalls" do
      # VCR.use_cassette('hyundai', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Hyundai.new("KM8SM4HF1EU042217")
        expect(@checker.recalls).to be_empty
      # end
    end

    it "vin_invalid? for fake VIN KM8SM4HF1EU040000" do
      # VCR.use_cassette('hyundai', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Hyundai.new("KM8SM4HF1EU040000")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      # end
    end
=end

end