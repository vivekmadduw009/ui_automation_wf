# frozen_string_literal: true
require_relative 'base_page'
require_relative '../spec_helper'
class TicketDesk_page< BasePage

  include Capybara::DSL
  include RSpec::Matchers

  SUBJECT_LINK = "//table//a[contains(normalize-space(.), '%{subject}')]"
  NEXT_PAGE    = "(//div[@class='flex items-center space-x-3']/button)[2]"


  def click_subject(subject)
    puts "🔎 Looking for subject: #{subject}"

    # If success toast appears, wait for it to disappear
    if page.has_text?("Ticket created successfully", wait: 3)
      puts "✅ Success toast detected, waiting for it to disappear..."
      expect(page).to have_no_text("Ticket created successfully", wait: 10)
      puts "✅ Toast cleared."
    end

    # Start from top of page
    page.execute_script("window.scrollTo(0, 0)")

    loop do
      row_xpath = SUBJECT_LINK % { subject: subject }

      # 1. Try to find subject on current page
      if page.has_xpath?(row_xpath, wait: 2)
        puts "✅ Subject found on current page."
        find(:xpath, row_xpath, wait: 10).click
        puts "✅ Subject clicked."
        return
      end

      puts "ℹ️ Subject not found on this page. Checking Next button..."

      # 2. If no Next button, we’re at the last page
      unless page.has_xpath?(NEXT_PAGE, wait: 2)
        puts "❌ Next button not found. Reached last page."
        break
      end

      # 3. Wait until Next becomes enabled, then click it
      unless wait_for_next_enabled_and_click
        puts "❌ Next button never became enabled or clickable."
        break
      end

      # 4. Wait for table rows after going to next page
      expect(page).to have_xpath("//table//tr", wait: 10)
      puts "🔄 Table refreshed. Moving to next page..."
    end

    raise "❌ Subject '#{subject}' not found in table on any page"
  end

  def wait_for_next_enabled_and_click
    next_btn = nil

    Timeout.timeout(20) do
      loop do
        next_btn = find(:xpath, NEXT_PAGE, wait: 5)

        disabled_attr = next_btn[:disabled].to_s.strip.downcase
        is_disabled = (disabled_attr == "true")

        puts "🧭 Next button state -> disabled_attr: #{disabled_attr.inspect} | FINAL disabled? #{is_disabled}"

        break unless is_disabled
        sleep 0.3
      end
    end

    next_btn = find(:xpath, NEXT_PAGE, wait: 5)


    page.execute_script("arguments[0].click();", next_btn)

    puts "👉 Clicked Next button."
    true

  rescue Timeout::Error
    puts "⏱ Timeout waiting for Next button to become enabled."
    false
  end


  def ticket_row_by_subject(subject)
    find(
      :xpath,
      "//table//tr[.//a[contains(normalize-space(.), '#{subject}')]]",
      wait: 10
    )
  end

  def list_values_for(subject)
    row = ticket_row_by_subject(subject)

    {
      subject:   row.find(:xpath, "./td[2]").text,
      requester: row.find(:xpath, "./td[3]").text,
      status:  row.find(:xpath, "./td[4]").text.downcase,
      priority:    row.find(:xpath, "./td[5]").text.downcase,
      source:    row.find(:xpath, "./td[6]").text.downcase,
      assigned_to:  row.find(:xpath, "./td[7]").text,
      created_at:  row.find(:xpath, "./td[8]").text,


    }
  end

end
