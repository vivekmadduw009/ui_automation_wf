# spec/pages/base_page.rb
require 'capybara/dsl'


class BasePage
  include Capybara::DSL


  def initialize
    @wait_time = Capybara.default_max_wait_time
  end


  def visit_path(path = '/')
    visit(path)
  end


  def find_element(selector_type, locator, **opts)
    find(selector_type, locator, **opts)
  end


  def click_element(selector_type, locator, **opts)
    find(selector_type, locator, **opts).click
  end


  def set_text(selector_type, locator, text, **opts)
    find(selector_type, locator, **opts).set(text)
  end


  def visible?(selector_type, locator, **opts)
    has_selector?(selector_type, locator, **opts)
  end
end