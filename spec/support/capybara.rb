# spec/support/capybara.rb
require 'capybara'
require 'selenium-webdriver'


Capybara.run_server = false
Capybara.default_max_wait_time = 10
Capybara.app_host = ENV['APP_HOST'] || 'http://localhost:4200/'


Selenium::WebDriver.logger.level = :error


Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless=new') if Gem::Version.new(Selenium::WebDriver::VERSION) >= Gem::Version.new('4.0')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1920,1080')
  options.add_argument('--ignore-certificate-errors')
  options.add_argument('--disable-gpu')


  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end


# Non-headless (for local debugging)
Capybara.register_driver :selenium_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--start-maximized')
  options.add_argument('--ignore-certificate-errors')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_argument('--log-level=3')
  options.add_argument('--disable-logging')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end


# Default drivers
Capybara.default_driver = ENV['CI'] ? :selenium_chrome : :selenium_chrome
Capybara.javascript_driver = :selenium_chrome