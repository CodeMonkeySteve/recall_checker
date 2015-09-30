require 'spec_helper'

describe RecallChecker::Adaptors::Mazda do

    it "the tests are currently bypassed because VCR cannot be used in this case" do
      # Uncomment the following tests if it's needed.
      # VCR is disabled here because all pages are redirected to the same URL,
      # therefore VCR loads same data for different cases
      true
    end

=begin

    it "loads recall data for VIN JM3TB28A380142569 with an open recall" do
      @checker = RecallChecker::Adaptors::Mazda.new("JM3TB28A380142569")
      expect(@checker.response).not_to be_empty
      expect(@checker.recalls.count).to eq 1

      r = @checker.recalls.first
      expect(r['title']).to start_with "Water may enter the front suspension"
      expect(r['created_at']).to eq Time.parse("16 Jul 2015")
      expect(r['nhtsa_id']).to eq "15V-451"
      expect(r['manufacturer_id']).to eq "8515G"
      expect(r['description']).to start_with "Water may enter the front suspension"
      expect(r['risks']).to start_with "The vehicle may experience significant loss"
      expect(r['remedy']).to start_with "Dealers will inspect the lower control arm ball joints"
      expect(r['status']).to start_with "Recall Incomplete"
      expect(r['notes']).to eq nil
    end

    # it "loads recall data for VIN JM1GJ1U59E1102132 with 2 open recalls" do
    #   @checker = RecallChecker::Adaptors::Mazda.new("JM1GJ1U59E1102132")
    #   expect(@checker.response).not_to be_empty
    #   expect(@checker.recalls.count).to eq 2
    # end

    it "returns [] for real VIN JM3TB2CA8F0451524 with no recalls" do
      @checker = RecallChecker::Adaptors::Mazda.new("JM3TB2CA8F0451524")
      expect(@checker.recalls).to be_empty
    end

    it "vin_invalid? for invalid VIN WDDLJ6FB8FA150000" do
        @checker = RecallChecker::Adaptors::Mazda.new("WDDLJ6FB8FA150000")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
    end
=end


end