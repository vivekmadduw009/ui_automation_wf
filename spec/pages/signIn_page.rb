# frozen_string_literal: true
require_relative 'base_page'
require_relative '../spec_helper'

class SignInPage < BasePage
  USERNAME="//input[@type='email']"
  PASSWORD="//input[@type='password']"
  LOGIN="//button[@type='submit']"
  ERROR="//div[@class='mb-4 p-3 text-sm bg-red-100 text-red-700 rounded']"



  def visit_homepage
    TestLogger.step "Visiting Homepage"
    visit_path('/')
  end
  def invalid_credentials
    TestLogger.step "Invalid Credentials"
    #find(:css, USERNAME, wait: 5).set(username)
    find(:xpath,USERNAME, wait: 5).set("test@gksi.com")
    find(:xpath,PASSWORD, wait: 5).set("dsgysaud")
    find(:xpath,LOGIN, wait: 5).click
    find(:xpath,ERROR).text


    end
end
