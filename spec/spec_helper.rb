# spec/spec_helper.rb
require 'rspec'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'allure-rspec'
require 'dotenv'
require_relative 'support/logger'
require "yaml"
require "erb"


Dotenv.load if defined?(Dotenv)

# Calling data from test_data file



AllureRspec.configure do |c|
  c.results_directory = "reports/allure-results"
  c.clean_results_directory = true
end

# Require support files
Dir[File.expand_path('support/**/*.rb', __dir__)].each { |file| require_relative file }
Dir[File.expand_path('pages/**/*.rb', __dir__)].each { |file| require_relative file }

RSpec.configure do |config|
  config.formatter = AllureRspec::RSpecFormatter

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Allow `:focus` tag for dev runs
  config.filter_run_when_matching :focus

  config.before(:suite) do
    TestLogger.step "Clearing Reports directory"
    FileUtils.rm_rf("reports")
    FileUtils.mkdir("reports")
    TestLogger.step "Reports directory created"
  end

  config.before(:each) do
    Capybara.reset_sessions!
  end

  config.after(:each) do |example|
    if example.exception
      filename = "screenshot-#{Time.now.to_i}.png"
      screenshot_path = File.join("reports/allure-results", filename)
      Capybara.page.save_screenshot(screenshot_path)
      Allure.add_attachment(
        name: "Failure screenshot",
        source: File.open(screenshot_path),
        type: Allure::ContentType::PNG
      )
      TestLogger.step "Screenshot saved"
      raise example.exception if example.exception
    end
  end

  config.after(:suite) do
    TestLogger.step "Generating Allure Report"
    system("allure generate reports/allure-results --clean -o reports/allure-report")
    TestLogger.step "Allure Report Generated at reports/allure-report"
  end


end