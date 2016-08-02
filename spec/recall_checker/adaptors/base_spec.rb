require 'spec_helper'

describe RecallChecker::Adaptors::Base, "when there are no recalls" do

  before :each do
    @checker = RecallChecker::Adaptors::Base.new('11111111111111111')
    allow(@checker).to receive(:parsed_response) { Hash['recalls' => []] }
  end

  it "#has_recalls? returns `false`" do
    expect(@checker).not_to have_recalls
  end
  
  it "#recalls returns empty []" do
    expect(@checker.recalls).to eq []
  end
end

describe RecallChecker::Adaptors::Base, "when there are recalls" do

  before :each do
    @checker = RecallChecker::Adaptors::Base.new('11111111111111111')
    @date_created = Date.new(2015,8,30) 
    @date_updated = Date.new(2015,9,15) 
    allow(@checker).to receive(:parsed_response) do 
      {
        'recalls' => [
          {
            'title' => 'Sample Recall',
            'nhtsa_id' => 'NHTSA1',
            'manufacturer_id' => 'MNF1',
            'description' => 'Sample dummy recall body',
            'risks' => '...',
            'remedy' => '...',
            'status' => '...',
            'notes' => '...',
            'created_at' => @date_created.to_s,
            'updated_at' => @date_updated.to_s
          }
        ]  
      }
    end
  end

  it "#has_recalls? returns `true`" do
    expect(@checker).to have_recalls
  end
  
  it "passes recall hash with no change when no conversion" do
    expect(@checker.recalls.first).to eq @checker.recalls_raw.first.merge('created_at' => @date_created, 'updated_at' => @date_updated)
  end

  it "raises ServiceError when the server returns an empty response" do
    @checker2 = RecallChecker::Adaptors::Base.new("11111111111111111")
    allow(@checker2).to receive(:url) { "http://www.example.com" }
    stub_request(:any, "http://www.example.com").to_return(headers: { 'Content-Length' => 0 })
    expect { @checker2.recalls }.to raise_error RecallChecker::ServiceError
  end

  it "raises ServiceError when the server returns status not equal to 200" do
    @checker2 = RecallChecker::Adaptors::Base.new("11111111111111111")
    allow(@checker2).to receive(:url) { "http://www.example.com" }
    stub_request(:any, "http://www.example.com").to_return(body: "oops", status: 403, headers: { 'Content-Length' => 4 })
    expect { @checker2.recalls }.to raise_error RecallChecker::ServiceError
  end

  it "raises MakeError for unsupported makes" do
    expect { RecallChecker.find_by_make_and_vin("parovoz","11111111111111111") }.to raise_error RecallChecker::MakeError
    expect { RecallChecker.find_by_make_and_vin("bmw","11111111111111111") }.not_to raise_error
  end
end

describe RecallChecker::Adaptors::Base, "VIN checks in the constructor" do
  it "validates VINs properly" do
    expect { RecallChecker::Adaptors::Base.new("1234") }.to raise_error RecallChecker::VinError
    expect { RecallChecker::Adaptors::Base.new("FAKEVIN") }.to raise_error RecallChecker::VinError
    expect { RecallChecker::Adaptors::Base.new("11111111111111111") }.not_to raise_error
  end
end
