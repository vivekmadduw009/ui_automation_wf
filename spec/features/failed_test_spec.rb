# frozen_string_literal: true

require 'rspec'

RSpec.describe 'FailedTest' do
  let(:creds) { config_credentials }
  let(:sign_in_page) { SignIn_page.new }
  let(:dashboard_page) { DashboardPage.new }
  let(:create_ticket_page) { CreateTicket_page.new }
  include Capybara::DSL
  include RSpec::Matchers
  #Testing title of tab
  it "Title of Dashboard" do
    sign_in_page.visit_homepage
    sign_in_page.login(username: creds["adminUsername"],password: creds["adminPassword"])
    sleep 5
    title=find(:xpath, "(//div[@class='flex items-center gap-4'])[1]/h1").text
    expect(title).to eq("Dashboard")


  end
end
