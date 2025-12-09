# frozen_string_literal: true
require_relative 'base_page'
require_relative '../spec_helper'

class TicketDetailsPage <BasePage

  include Capybara::DSL
  include RSpec::Matchers

  SUBJECT="//div[@class='flex flex-col']/h2"
  REQUESTER_NAME="//div[@class='flex flex-col']/p/span[1]"
  CREATED_DATE="//div[@class='flex flex-col']/p/span[2]"
  DESCRIPTION_LABEL="//h3[text()='Description']"
  DESCRIPTION_TEXT="//p[@class='mt-6']"
  COMMENT_HEADER="//h2[@class='text-2xl font-bold text-gray-800']"
  COMMENT_COUNT="//p[@class='text-sm text-gray-500 mt-1']"
  COMMENT_TEXT_FIELD="//input[@placeholder='Write a comment...']"
  ADD_COMMENT="//button[text()='Add Comment']"
  COMMENT_NAME="//span[@class='font-semibold text-gray-900']"
  COMMENT_DESCRIPTION="//p[@class='text-gray-700 break-words']"
  DELETE_COMMENT="//button[normalize-space()='Delete']"


  def validate_ticket_details(subject,requester,description)
    subject_match=find(:xpath, SUBJECT).text
    expect(subject_match).to match(subject)
    requester_name=find(:xpath, REQUESTER_NAME).text
    expect(requester_name).to match(requester)
    des_label=find(:xpath, DESCRIPTION_LABEL).text
    expect(des_label).to match("Description")
    desc=find(:xpath, DESCRIPTION_TEXT).text
    expect(desc).to match(description)
    header=find(:xpath,COMMENT_HEADER).text
    expect(header).to eq("Comments")
    add_button_text=find(:xpath,ADD_COMMENT).text
    expect(add_button_text).to eq("Add Comment")


  end
  def add_comment(comment,name)

    initial_count=find(:xpath,COMMENT_COUNT).text
    expect(initial_count).to match("0 comments")
    find(:xpath, COMMENT_TEXT_FIELD).set(comment)
    find(:xpath, ADD_COMMENT, wait: 10).click
    after_count=find(:xpath,COMMENT_COUNT).text
    expect(after_count).to match("1 comment")
    comment_name=find(:xpath,COMMENT_NAME).text
    expect(comment_name).to eq(name)
    description=find(:xpath,COMMENT_DESCRIPTION).text
    expect(description).to eq(comment)
    delete_comment=find(:xpath,DELETE_COMMENT).text
    expect(delete_comment).to eq("Delete")
    find(:xpath,DELETE_COMMENT).click



  end
end
