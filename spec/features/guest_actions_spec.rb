require 'rails_helper'
require_relative '../spec_helper.rb'

describe 'Interacting with the site as as guest' do
  # Creates a temporary user with email 'test@sheffield.ac.uk' and password as below
  # from the factory bot file
  let!(:user) { FactoryBot.create(:user, password: "password123") }
  let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "password123", admin: true) }
  specify 'Guest can create an account and then logout' do
    visit '/'
    click_on 'Login'
    click_on 'Sign up'
    fill_in  'user_email', with: "new_user@sheffield.ac.uk"
    fill_in  'user_password', with: "Password1"
    fill_in  'user_password_confirmation', with: "Password1"
    click_on  'Sign up'

    expect(page).to have_content("Welcome! You have signed up successfully.")
    expect(page).to have_current_path('/')

    logout_user

    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Login'
  end

  specify 'Guest can login as a user' do
    sign_in_user

    expect(page).to have_content 'my.email@sheffield.ac.uk'
    expect(page).to have_content 'Logout'

    logout_user
    
    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Login'
  end
end