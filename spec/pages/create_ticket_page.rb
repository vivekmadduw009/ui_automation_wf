# frozen_string_literal: true
require_relative 'base_page'
require_relative '../spec_helper'
class CreateTicket_page<BasePage

  include Capybara::DSL
  include RSpec::Matchers

  NEW_TICKET= "//h1[@class='text-2xl font-semibold mb-6 text-gray-800']"
  REQUESTER_LABEL ="//label[.='Requestor']"
  REQUESTER_TEXT_FIELD="//input[@placeholder='Search']"
  SUBJECT_LABEL="(//label[@class='block text-sm font-normal text-gray-700 mb-2'])[1]"
  SUBJECT_TEXT_FIELD="//input[@type='text']"
  SUBJECT_ERROR="//input[@type='text']/following-sibling::p"
  SOURCE_DROPDOWN_LABEL="(//label[@class='block text-sm font-normal text-gray-700 mb-2'])[2]"
  SOURCE_DROPDOWN="//select[.//option[@value='email'] and .//option[@value='phone']]"
  STATUS_DROPDOWN_LABEL="(//label[@class='block text-sm font-normal text-gray-700 mb-2'])[3]"
  STATUS_DROPDOWN="//select[.//option[normalize-space()='Select status']]"
  URGENCY_DROPDOWN_LABEL="(//label[@class='block text-sm font-normal text-gray-700 mb-2'])[4]"
  URGENCY_DROPDOWN="//select[.//option[@value='low'] and .//option[@value='medium'] and .//option[@value='high']]"
  ASSIGN_TO_LABEL="//label[text()='Assign To']"
  ASSIGN_TO_DROPDOWN="#assignee"
  DESCRIPTION_HEADER="//label[contains(normalize-space(.), 'Description')]"
  DESCRIPTION_ERROR="//textarea/following-sibling::p"
  DESCRIPTION_TEXT_FIELD="//textarea"
  CREATE_BUTTON="//button[@type='submit']"
  CANCEL_BUTTON="//button[@class='px-6 py-2 border border-gray-300 rounded text-gray-700 hover:bg-gray-50 font-medium']"
  DELETE_FIRST_TICKET="(//tr)[2]/td[10]/div/button[2]"
  FIRST_TICKET_SUBJECT="(//tr)[2]/td[2]/a"

  def assert_text
    req_label=find(:xpath,REQUESTER_LABEL).text
    expect(req_label).to eq("Requestor")
    sub_label=find(:xpath,SUBJECT_LABEL).text
    expect(sub_label).to eq("Subject *")
    source_label=find(:xpath,SOURCE_DROPDOWN_LABEL).text
    expect(source_label).to eq("Source")
    status_label=find(:xpath,STATUS_DROPDOWN_LABEL).text
    expect(status_label).to eq("Status *")
    urgency_label=find(:xpath,URGENCY_DROPDOWN_LABEL).text
    expect(urgency_label).to eq("Priority")
    assign_label=find(:xpath,ASSIGN_TO_LABEL).text
    expect(assign_label).to eq("Assign To")
    des_label=find(:xpath,DESCRIPTION_HEADER).text
    expect(des_label).to eq("Description *")
    create_button=find(:xpath,CREATE_BUTTON).text
    expect(create_button).to eq("Create Ticket")
    cancel_button=find(:xpath,CANCEL_BUTTON).text
    expect(cancel_button).to eq("Cancel")

  end



  def description_value
    find(:xpath, DESCRIPTION_TEXT_FIELD).value
  end

  def create_ticket(subject,description)

    find(:xpath,SUBJECT_TEXT_FIELD).set(subject)
    page.execute_script("window.scrollBy(0, 500)")
    find(:xpath,DESCRIPTION_TEXT_FIELD,wait:10).set(description)
    length= description_value.length
    find(:xpath,CREATE_BUTTON).click
    expect(page).to have_text("Ticket created successfully")
    expect(page).to have_no_text("Ticket created successfully", wait: 10)
    length
  end
  def clear_subject
    find(:xpath, SUBJECT_TEXT_FIELD).set('')
  end

  def clear_description
    find(:xpath, DESCRIPTION_TEXT_FIELD).set('')
  end
  def error_check(xpath, text)

    error=find(:xpath,xpath, wait: 5).text
    expect(error).to eq(text)
  end

  def delete_first_ticket
    find(:xpath,DELETE_FIRST_TICKET).click
  end

end
