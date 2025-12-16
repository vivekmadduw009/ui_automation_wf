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
  formatted_date = Time.now.strftime("%d %b %Y, %I:%M %p")
  subject = "Automation_#{Time.now.strftime("%Y%m%d_%H%M%S")}"
  description="This record was created by automation script."
  comment="This is an automated test comment"
  default_source="email"
  default_priority="low"
  default_assign=""
  default_status="open"
  long_text = "A" * 256

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
    #Checking data in List
    list_values = list.list_values_for(subject)

    expect(list_values[:subject]).to eq(subject)
    expect(list_values[:requester]).to eq(creds["adminUsername"])
    expect(list_values[:priority]).to eq(default_priority.downcase)
    expect(list_values[:status]).to eq(default_status.downcase)
    expect(list_values[:source]).to eq(default_source.downcase)
    expect(list_values[:assigned_to]).to eq(default_assign.downcase)
    expect(list_values[:created_at]).to eq(formatted_date)

    #Checking same in database
    result = db_client.query("SELECT * FROM tickets WHERE title = '#{subject}';")
    expect(result.count).to be > 0

    row_array = result.first
    raise "No row found for subject #{subject}" if row_array.nil?

    row_hash = row_array.to_h

    #puts "DB row_hash => #{row_hash.inspect}"

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


  it "create ticket with negative scenario" do
    dashboard_page.click_create_ticket
    create_ticket_page.create_ticket("",description)
    create_ticket_page.error_check(CreateTicket_page::SUBJECT_ERROR, "Title is required")
    create_ticket_page.clear_description
    create_ticket_page.create_ticket(subject,"")
    create_ticket_page.error_check(CreateTicket_page::DESCRIPTION_ERROR,"Description is required")
  end

  it "create ticket with max length" do
    dashboard_page.click_create_ticket
    length = create_ticket_page.create_ticket(long_text, long_text)
    expect(length).to eq(200)
  end


end
