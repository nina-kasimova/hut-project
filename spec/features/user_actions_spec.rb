require 'rails_helper'
require_relative '../spec_helper.rb'

describe 'Interacting with site as a user' do
  # Creates a temporary user with email 'my.email@sheffield.ac.uk' and password as below
  # from the factory bot file
  let!(:user) { FactoryBot.create(:user, password: "password123") }
  let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "password123", admin: true) }

  specify 'Guest can login as a user' do
    sign_in_user

    expect(page).to have_content 'my.email@sheffield.ac.uk'
    expect(page).to have_content 'Logout'

    logout_user
    
    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Login'
  end

  specify 'User can visit edit account information page' do
    sign_in_user
    visit '/users/edit'

    expect(page).to have_current_path('/users/edit')
    expect(page).to have_content('Cancel my account')
  end

  specify 'User can change account information' do
    sign_in_user
    visit '/users/edit'

    expect(page).to have_current_path('/users/edit')
    expect(page).to have_content('Cancel my account')

    fill_in "user_email", with: "new@sheffield.ac.uk"
    fill_in 'user_current_password', with: "password123"
    click_button 'Update'

    expect(page).to have_current_path("/")
    expect(page).to have_content("new@sheffield.ac.uk")
    expect(page).to have_content("Your account has been updated successfully.")
  end

  specify 'Guest can create an account and then logout' do
    create_user_account

    expect(page).to have_content("Welcome! You have signed up successfully.")
    expect(page).to have_current_path('/')

    logout_user

    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Login'
  end

  # specify 'User can cancel account' do
  #   # Currently won't work (see method in spec_helper.rb for details)
  #   delete_account

  #   expect(page).to have_current_path('/')
  #   expect(page).to have_content('Bye! Your account has been successfully cancelled. We hope to see you again soon.')
  # end
end