# frozen_string_literal: true


RSpec.describe "Create Ticket", type: :feature do

  let(:sign_in_page) { SignInPage.new }
  let(:dashboard_page) { DashboardPage.new }
  let(:create_ticket_page) { CreateTicketPage.new }
  let(:creds) { config_credentials }
  let(:details) { TicketDetailsPage.new }
  let(:requester)  { creds["adminUsername"] }

  require "date"
  subject = "Automation_#{Time.now.strftime("%Y%m%d_%H%M%S")}"
  description="This record was created by automation script."
  comment="This is an automated test comment"


  before(:each) do
    sign_in_page.visit_homepage
    sign_in_page.login(username: creds["adminUsername"],password: creds["adminPassword"])

  end

  it "Assert create ticket" do
    dashboard_page.click_create_ticket
    create_ticket_page.assert_text
  end

  it "create ticket" do
    dashboard_page.click_create_ticket
    create_ticket_page.create_ticket(subject,description)
    details.validate_ticket_details(subject,requester,description)
    details.add_comment(comment,"admin")
  end
end
