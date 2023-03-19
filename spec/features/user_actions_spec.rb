require 'rails_helper'
require_relative '../spec_helper.rb'

RSpec.describe 'Interacting with site as a user', type: :feature do
  # Creates a temporary user with email 'test@sheffield.ac.uk' and password as below
  # from the factory bot file
  let!(:user) { FactoryBot.create(:user, password: "password123") }
  let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "password123", admin: true) }

  before :each do
    nil
  end
  
  specify 'can visit edit account information page' do
    sign_in_user
    visit '/users/edit'

    expect(page).to have_current_path('/users/edit')
    expect(page).to have_content('Cancel my account')
  end

  specify 'can change account information' do
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

  specify 'can expand an elective' do
    # This is the elective with ID = 5 due to admin_spec running first
    # And temporary electives are still in existence
    signin_user_with_elective
    
    expect(page).to have_current_path('/')

    click_on 'Elective'
    click_on 'Show'

    expect(page).to have_content("Elective details")
    expect(page).to have_link('Back')
    expect(page).to have_current_path('/electives/5')
  end

  specify 'cannot create any new electives' do
    sign_in_user
    visit '/electives/new'

    expect(page).to have_content("You are not authorized to access this page.")
    expect(page).to have_current_path("/")
  end

  # specify 'User can cancel account' do
  #   # Currently won't work (see method 'delete_account' in spec_helper.rb for details)
  #   delete_account

  #   expect(page).to have_current_path('/')
  #   expect(page).to have_content('Bye! Your account has been successfully cancelled. We hope to see you again soon.')
  # end
end

RSpec.describe 'Searching and filtering electives as a user', type: :feature do
  let!(:user) { FactoryBot.create(:user, password: "password123") }
  let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "password123", admin: true) }

  specify 'can search and filter electives by titles' do
    # This is the elective with ID = 6
    signin_user_with_elective
    visit '/search'
    select "Test Elective", :from => "search_Title"
    click_on 'Search for Electives'

    expect(page).to have_content("Found Electives")
    expect(page).to have_content("Test Elective")
    expect(page).to have_content("Lorem")
  end
end