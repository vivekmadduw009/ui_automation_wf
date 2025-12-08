# frozen_string_literal: true
require_relative 'base_page'
require_relative '../spec_helper'

class SignInPage < BasePage
  include Capybara::DSL
  include RSpec::Matchers

  USERNAME="//input[@type='email']"
  EMAIL_LABEL="//form[@class='space-y-4']/div[1]/label"
  PASSWORD_LABEL="//form[@class='space-y-4']/div[2]/label"
  PASSWORD="//input[@type='password']"
  LOGIN="//button[@type='submit']"
  ERROR="//div[@class='mb-4 p-3 text-sm bg-red-100 text-red-700 rounded']"



  def visit_homepage
    TestLogger.step "Visiting Homepage"
    visit_path('/')
  end


  def  login(username:, password:)
    TestLogger.step "Login credential"

    find(:xpath, USERNAME, wait: 5).set(username)
    find(:xpath, PASSWORD, wait: 5).set(password)
    find(:xpath, LOGIN, wait: 5).click
  end

  def invalid_credentials
    TestLogger.step "Invalid Credentials"
    find(:xpath,ERROR).text

  end

  def assert_login_screen
    email =find(:xpath,EMAIL_LABEL).text
    expect(email).to eq("Email")
    password =find(:xpath,PASSWORD_LABEL).text
    expect(password).to eq("Password")
    login_label =find(:xpath,LOGIN).text
    expect(login_label).to eq("Login")



  end


end
