# spec/pages/dashboard_page.rb
require_relative 'base_page'
require_relative '../spec_helper'


class DashboardPage < BasePage
  # Prefer CSS selectors where possible; keep XPaths if necessary
  LOGIN_LINK = "a[href='/support/login']"
  USERNAME = "#username"
  PASSWORD = "#password"
  LOGIN_BUTTON = "button[data-testid='login-button']"
  DASHBOARD_TITLE = "span#dashboard-name-title"
  PORTAL_LOGO = "h1.portal-name.hide-on-mobile"
  OPEN_TICKETS = "section[data-test-id='widget-layout-0-open-tickets']"
  OPEN_TICKETS_HEADER = "//span[@class='view-selected']//span[contains(., 'Open Tickets')]"


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
    visible?(:css, DASHBOARD_TITLE, wait: 10)
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

  def open_tickets
    TestLogger.step "Navigating to Open Tickets Section"
    page.has_css?(OPEN_TICKETS, visible: true)
    find(:css, DashboardPage::OPEN_TICKETS, wait: 10)
    click_element(:css, OPEN_TICKETS)
    page.has_xpath?(OPEN_TICKETS_HEADER, visible: true)
    TestLogger.info "Navigated to Open Tickets"
  end
end