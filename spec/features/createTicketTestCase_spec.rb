# frozen_string_literal: true
require_relative '../spec_helper'

RSpec.describe "Create Ticket", type: :feature do

  let(:sign_in_page) { SignIn_page.new }
  let(:dashboard_page) { DashboardPage.new }
  let(:create_ticket_page) { CreateTicket_page.new }
  let(:creds) { config_credentials }
  let(:details) { TicketDetail_page.new }
  let(:list) {TicketDesk_page.new }
  let(:requester)  { creds["adminUsername"] }
  let(:db_client) { DBClient }

  require "date"
  subject = "Automation_#{Time.now.strftime("%Y%m%d_%H%M%S")}"
  description="This record was created by automation script."
  comment="This is an automated test comment"
  default_source="email"
  default_priority="low"
  default_status="open"

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
    create_ticket_page.create_ticket(subject, description)

    result = db_client.query("SELECT * FROM tickets WHERE title = '#{subject}';")
    expect(result.count).to be > 0

    row_array = result.first
    raise "No row found for subject #{subject}" if row_array.nil?

    row_hash = row_array.to_h

    puts "DB row_hash => #{row_hash.inspect}"

    # ✅ Now assert using row_hash (not `row`)
    expect(row_hash["description"]).to eq(description)
    expect(row_hash["priority"]).to eq(default_priority)
    expect(row_hash["assign_to"]).to be_nil
    expect(row_hash["requestor"]).to eq(creds["adminUsername"])
    expect(row_hash["source"]).to eq(default_source)
    expect(row_hash["status"]).to eq(default_status)
    list.click_subject(subject)
    details.validate_ticket_details(subject,requester,description)
    details.add_comment(comment,"admin")
    details.delete_comment

  end
end
