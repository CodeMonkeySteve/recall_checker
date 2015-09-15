require 'spec_helper'

describe RecallChecker::Adaptors::Ford do

    it "loads recall data for VIN 1ZVBP8AMXD5277023 with recalls" do
      VCR.use_cassette('ford', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Ford.new("1ZVBP8AMXD5277023")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1
        expect(@checker.recalls.first['nhtsa_id']).to eq "15V319"
      end
    end

    it "returns [] for real VIN 1FADP5AU9DL504830 with FSAs but no recalls" do
      VCR.use_cassette('ford', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Ford.new("1FADP5AU9DL504830")
        expect(@checker.recalls).to be_empty
      end
    end

    it "returns [] for fake VIN 1ZVBP8AMXD5277000" do
      VCR.use_cassette('ford', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Ford.new("1ZVBP8AMXD5277000")
        expect(@checker.recalls).to be_empty
      end
    end

end