# frozen_string_literal: true
require_relative 'base_page'
require_relative '../spec_helper'
class TicketDetail_page < BasePage
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

  def click_ticket

  end

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

  def check_comment_count(count)
    count_comment=find(:xpath,COMMENT_COUNT).text
    comment_count_text =
      if count == 1
        "1 comment"
      else
        "#{count} comments"
      end
    expect(count_comment).to match(comment_count_text)
  end


  def add_comment(comment,name)

    initial_count = find(:xpath, COMMENT_COUNT).text.to_i
    check_comment_count(initial_count)
    find(:xpath, COMMENT_TEXT_FIELD).set(comment)
    find(:xpath, ADD_COMMENT, wait: 10).click
    sleep 5
    check_comment_count(1)
    comment_name=find(:xpath,COMMENT_NAME).text
    expect(comment_name).to eq(name)
    description=find(:xpath,COMMENT_DESCRIPTION).text
    expect(description).to eq(comment)

  end

  def delete_comment
    initial_count = find(:xpath, COMMENT_COUNT).text.to_i
    delete_comment=find(:xpath,DELETE_COMMENT).text
    expect(delete_comment).to eq("Delete")
    find(:xpath,DELETE_COMMENT, wait:10).click
    updated_count = find(:xpath, COMMENT_COUNT, wait: 10).text.to_i
    check_comment_count(updated_count)
  end

end
