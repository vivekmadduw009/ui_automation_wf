require_relative '../spec_helper'

RSpec.describe 'Wissen Technology - Freshservice', type: :feature do
  let(:dashboard_page) { DashboardPage.new }
  let(:creds) { config_credentials }

  before(:each) do
    TestLogger.step "Performing Login"
    dashboard_page.login_once(creds)
  end

  it 'Log into the Dashboard', :regression do
    TestLogger.info "Already logged in"
  end

  it 'Navigate to Open Tickets', :regression, :sanity do
    dashboard_page.open_tickets
  end

end