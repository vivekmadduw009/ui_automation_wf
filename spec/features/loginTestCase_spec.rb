require_relative '../spec_helper'


RSpec.describe "Login Scenarios", type: :feature  do

  let(:sign_in_page) { SignIn_page.new }
  let(:dashboard_page) { DashboardPage.new }
  let(:creds) { config_credentials }

  before(:each) do
    TestLogger.step "Opening the url"
    sign_in_page.visit_homepage
  end

  it "Login screen text" do

    sign_in_page.assert_login_screen

  end

  it "Valid Username and Valid Password" do

    sign_in_page.login(username: creds["adminUsername"],password: creds["adminPassword"])
    dashboard_page.logged_in?

  end

  it "Invalid Username and Valid Password" do

    sign_in_page.login(username: "hsgjhsan@gmail.com",password: "password123")
    msg = sign_in_page.invalid_credentials
    expect(msg).to include("Invalid email or password")

  end
  it "Valid Username and Invalid Password" do

    sign_in_page.login(username: "admin@gmail.com",password: "hahywquh776")
    msg = sign_in_page.invalid_credentials
    expect(msg).to include("Invalid email or password")

  end

  it "Invalid Username and Invalid Password" do

    sign_in_page.login(username: "hsgjhsan@gmail.com",password: "hahywquh776")
    msg = sign_in_page.invalid_credentials
    expect(msg).to include("Invalid email or password")

  end
end