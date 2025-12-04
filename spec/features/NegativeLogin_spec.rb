require_relative '../spec_helper'


RSpec.describe "Invalid scenarios test", type: :feature  do

  let(:sign_in_page) { SignInPage.new }
  let(:creds) { config_credentials }




  it "Invalid scenario" do
    sign_in_page.visit_homepage
    msg = sign_in_page.invalid_credentials
    expect(msg).to include("Invalid email or password")

  end

end