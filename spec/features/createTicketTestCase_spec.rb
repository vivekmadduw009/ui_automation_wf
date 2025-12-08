# frozen_string_literal: true


RSpec.describe "Create Ticket", type: :feature do
  let(:sign_in_page) { SignInPage.new }
  let(:dashboard_page) { DashboardPage.new }
  let(:create_ticket_page) { CreateTicketPage.new }
  let(:creds) { config_credentials }

  before(:each) do
    sign_in_page.visit_homepage
    sign_in_page.login(username: "admin@gmail.com",password: "password123")

  end

  it "Assert create ticket" do
    dashboard_page.click_create_ticket
    create_ticket_page.assert_text
  end

  it "create ticket" do
    dashboard_page.click_create_ticket
    create_ticket_page.create_ticket

  end


end
