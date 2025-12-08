# frozen_string_literal: true
require_relative 'base_page'
require_relative '../spec_helper'

class CreateTicketPage < BasePage
  include Capybara::DSL
  include RSpec::Matchers

  NEW_TICKET= "//h1[@class='text-2xl font-semibold mb-6 text-gray-800']"
  REQUESTER_LABEL ="//label[@class='text-sm font-normal text-gray-700']"
  REQUESTER_TEXT_FIELD="//input[@placeholder='Search']"
  SUBJECT_LABEL="(//label[@class='block text-sm font-normal text-gray-700 mb-2'])[1]"
  SUBJECT_TEXT_FIELD="(//input[@type='text'])[2]"
  SOURCE_DROPDOWN_LABEL="(//label[@class='block text-sm font-normal text-gray-700 mb-2'])[2]"
  SOURCE_DROPDOWN="//select[.//option[@value='email'] and .//option[@value='phone']]"
  STATUS_DROPDOWN_LABEL="(//label[@class='block text-sm font-normal text-gray-700 mb-2'])[3]"
  STATUS_DROPDOWN="//select[.//option[normalize-space()='Select status']]"
  URGENCY_DROPDOWN_LABEL="(//label[@class='block text-sm font-normal text-gray-700 mb-2'])[4]"
  URGENCY_DROPDOWN="//select[.//option[@value='low'] and .//option[@value='medium'] and .//option[@value='high']]"
  ASSIGN_TO_LABEL="//label[text()='Assign To']"
  ASSIGN_TO_DROPDOWN="#assignee"
  DESCRIPTION_HEADER="//label[text()='Description']"
  DESCRIPTION_TEXT_FIELD="//label[text()='Description']/following-sibling::textarea"
  CREATE_BUTTON="//button[@type='submit']"
  CANCEL_BUTTON="//button[@class='px-6 py-2 border border-gray-300 rounded text-gray-700 hover:bg-gray-50 font-medium']"


  def assert_text
    req_label=find(:xpath,REQUESTER_LABEL).text
    expect(req_label).to eq("Requester *")
    sub_label=find(:xpath,SUBJECT_LABEL).text
    expect(sub_label).to eq("Subject *")
    source_label=find(:xpath,SOURCE_DROPDOWN_LABEL).text
    expect(source_label).to eq("Source")
    status_label=find(:xpath,STATUS_DROPDOWN_LABEL).text
    expect(status_label).to eq("Status *")
    urgency_label=find(:xpath,URGENCY_DROPDOWN_LABEL).text
    expect(urgency_label).to eq("Urgency")
    assign_label=find(:xpath,ASSIGN_TO_LABEL).text
    expect(assign_label).to eq("Assign To")
    des_label=find(:xpath,DESCRIPTION_HEADER).text
    expect(des_label).to eq("Description")
    create_button=find(:xpath,CREATE_BUTTON).text
    expect(create_button).to eq("Create Ticket")
    cancel_button=find(:xpath,CANCEL_BUTTON).text
    expect(cancel_button).to eq("Cancel")

  end

  def create_ticket
    require "date"
    value = "User_#{Time.now.strftime("%Y%m%d_%H%M%S")}"
    find(:xpath,SUBJECT_TEXT_FIELD).set(value)
    page.execute_script("window.scrollBy(0, 500)")
    find(:xpath,DESCRIPTION_TEXT_FIELD).set("This record was created by automation script.")
    find(:xpath,CREATE_BUTTON).click


    end


end
