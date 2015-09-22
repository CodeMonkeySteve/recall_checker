require 'spec_helper'

describe RecallChecker::Adaptors::Subaru do

    it "loads recall data for VIN 4S3BNBN64F3047980 with open safety recalls" do
      VCR.use_cassette('subaru', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Subaru.new("4S3BNBN64F3047980")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to eq "Driver Assist System Delay in Warning Indicator"
        expect(r['created_at']).to eq Time.parse("4 Jun 2015")
        expect(r['nhtsa_id']).to eq "15V366000"
        expect(r['manufacturer_id']).to eq "WQS54"
        expect(r['description']).to start_with "Subaru of America, Inc. (Subaru) is recalling"
        expect(r['risks']).to start_with "If the automatic pre-collision braking system"
        expect(r['remedy']).to start_with "Subaru will notify owners"
        expect(r['status']).to eq "Open"
        expect(r['notes']).to include "SUBARU OF AMERICA, INC. has decided"
      end
    end

    it "returns [] for real VIN JF1GV7E63EG012430 with completed safety recalls" do
      VCR.use_cassette('subaru', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Subaru.new("JF1GV7E63EG012430")
        expect(@checker.recalls).to be_empty
      end
    end

    it "returns [] for real VIN 4S4WX82C764404261 with open non-safety recalls" do
      VCR.use_cassette('subaru', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Subaru.new("4S4WX82C764404261")
        expect(@checker.recalls).to be_empty
      end
    end

    it "returns [] for real VIN JF1GV8J66DL008289 with no recalls" do
      VCR.use_cassette('subaru', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Subaru.new("JF1GV8J66DL008289")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for fake VIN 4S3BNBN64F3040000" do
      VCR.use_cassette('subaru', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Subaru.new("4S3BNBN64F3040000")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end
end