require 'spec_helper'

describe RecallChecker::Adaptors::Toyota do

  it "bypassed because the tests currently require entering Captcha manually" do
    # Uncomment the following tests if it's needed.
    # VCR is disabled here because all pages are redirected to the same URL,
    # therefore VCR loads same data for different cases
    true
  end

=begin
  def show_captcha captcha_image_src
    f = File.open(@htmlfile,"w")
    f.puts '<html><body>'
    f.puts '<img src="' + captcha_image_src + '">'
    f.puts '</body></html>'
    f.close
    Launchy.open(File.expand_path(@htmlfile))
  end

  def solve_captcha
    @htmlfile = "tmp.html"
    @checker.request_captcha
    show_captcha @checker.captcha_image_src
    puts "Enter the captcha answer:"
    @checker.captcha_answer = $stdin.gets.chomp
    File.delete(@htmlfile)
  end

  it "loads recall data for VIN 4T1BD1EB1DU003609 with recalls" do
    @checker = RecallChecker::Adaptors::Toyota.new("4T1BD1EB1DU003609")
    solve_captcha
    r = @checker.recalls.first
    expect(r['title']).to start_with "Safety Recall"
    expect(r['created_at']).to eq Time.parse("17 Oct 2013")
    expect(r['nhtsa_id']).to eq "13V442"
    expect(r['manufacturer_id']).to eq "D0T"
    expect(r['description']).to start_with "Toyota is recalling certain model year"
    expect(r['risks']).to eq nil
    expect(r['remedy']).to start_with "Toyota will notify owners"
    expect(r['status']).to eq "Remedy Available"
    expect(r['notes']).to include "https://techinfo.toyota.com/techInfoPortal/staticcontent/en/techinfo/html/prelogin/docs/cp/d0ttofaq.pdf"
  end

  it "returns [] for real VIN 4T1BK1EB9DU030210 with no recalls" do
    @checker = RecallChecker::Adaptors::Toyota.new("4T1BK1EB9DU030210")
    solve_captcha
    expect(@checker.recalls).to be_empty
  end

  it "vin_invalid? for fake VIN 1ZVBP8AMXD5277000" do
    @checker = RecallChecker::Adaptors::Toyota.new("1ZVBP8AMXD5277000")
    solve_captcha
    expect { @checker.recalls }.to raise_error RecallChecker::VinError
  end
=end

end