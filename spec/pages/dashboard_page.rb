# spec/pages/dashboard_page.rb
require_relative 'base_page'
require_relative '../spec_helper'


class DashboardPage < BasePage
  include Capybara::DSL
  include RSpec::Matchers
  # Prefer CSS selectors where possible; keep XPaths if necessary
  DASHBOARD_TITLE = "//div[@class='flex items-center gap-4']/h1"
  CREATE_TICKET_ADD="//button[@class='w-7 h-7 shadow-lg flex items-center justify-center rounded-full bg-blue-600 hover:bg-blue-700 shadow text-white cursor-pointer transition']"
  CREATE_TICKET= "//p[text()='Create Ticket']"
  CREATE_TICKET_BOTTOM_TEXT="//p[text()='Report an issue']"



  def visit_homepage
    TestLogger.step "Visiting Homepage"
    visit_path('/')
    find(DashboardPage::PORTAL_LOGO, wait: 10)
    TestLogger.info "logo is visible"
  end


  def go_to_login
    TestLogger.step "Navigating to Login Page"
    click_element(:css, LOGIN_LINK)
  end


  def login(username:, password:)
    set_text(:css, USERNAME, username, wait: 5) if username
    find(:css, USERNAME, wait: 5).set(username)
    find(:css, PASSWORD, wait: 5).set(password)
    find(:css, LOGIN_BUTTON, wait: 5).click
  end


  def logged_in?
    visible?(:xpath, DASHBOARD_TITLE, wait: 10)
  end

  def login_once(creds)
    # return if logged_in?

    visit_homepage
    go_to_login
    TestLogger.step "Login to Dashboard"
    login(username: creds["username"], password: creds["password"])
    raise RSpec::Expectations::ExpectationNotMetError, "Login failed!" unless logged_in?
    TestLogger.info "Successfully logged in"
  end

  def click_create_ticket
    TestLogger.step "Click on Create Ticket"
    find(:xpath, CREATE_TICKET_ADD, wait: 3).click

    create_text_header = find(:xpath, CREATE_TICKET).text.strip
    expect(create_text_header).to eq("Create Ticket")

    create_text_bottom = find(:xpath, CREATE_TICKET_BOTTOM_TEXT).text.strip
    expect(create_text_bottom).to eq("Report an issue")

    find(:xpath,CREATE_TICKET, wait: 5).click
  end


  def open_tickets
    TestLogger.step "Navigating to Open Tickets Section"
    page.has_css?(OPEN_TICKETS, visible: true)
    find(:css, DashboardPage::OPEN_TICKETS, wait: 10)
    click_element(:css, OPEN_TICKETS)
    page.has_xpath?(OPEN_TICKETS_HEADER, visible: true)
    TestLogger.info "Navigated to Open Tickets"
  end
end