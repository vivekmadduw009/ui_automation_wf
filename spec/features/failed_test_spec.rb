# frozen_string_literal: true

require 'rspec'

RSpec.describe 'FailedTest' do
  let(:creds) { config_credentials }
  let(:sign_in_page) { SignIn_page.new }
  let(:dashboard_page) { DashboardPage.new }
  let(:create_ticket_page) { CreateTicket_page.new }

  #Right now refresh is showing error
  it "refresh dashboard screen" do
    sign_in_page.visit_homepage
    sign_in_page.login(username: creds["adminUsername"],password: creds["adminPassword"])
    sleep 5

    dashboard_page.click_create_ticket
    page.refresh
    create_ticket_page.assert_text

  end
end
