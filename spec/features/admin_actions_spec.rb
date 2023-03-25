require 'rails_helper'
require_relative '../spec_helper.rb'

RSpec.describe 'Interacting with site as an admin', type: :feature do
  # Creates a temporary user with email 'my.email@sheffield.ac.uk' and password as below
  # from the factory bot file
  let!(:user) { FactoryBot.create(:user, password: "password123") }
  let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "password123", admin: true) }

  before :each do
    nil
  end

  specify 'can login as an admin' do
    sign_in_admin

    expect(page).to have_current_path("/")

    logout_user

    expect(page).to have_current_path("/")
  end
  
  specify 'can visit the electives page' do
    elective_as_admin

    expect(page).to have_current_path('/electives')
    expect(page).to have_content("Listing Electives")
    expect(page).to have_link("New Elective")
  end

  specify 'can visit the admin dashboard' do
    visit_dashboard

    expect(page).to have_current_path('/admin_dashboard')
    expect(page).to have_content("Admin Dashboard")
    expect(page).to have_content("Questions")
  end

  specify 'can create new elective via admin tool page' do
    elective_as_admin

    expect(page).to have_link("New Elective")

    # This is elective with ID = 1
    create_new_elective

    expect(page).to have_content("Elective was successfully created.")
    expect(page).to have_content("Test Elective")
    expect(page).to have_current_path("/electives/1")

    click_on 'Back'

    expect(page).to have_current_path("/electives")
    within(:css, "table") { expect(page).to have_content 'Test Elective' }
    within(:css, "table") { expect(page).to have_content 'Lorem ipsum delorum' }
  end

  specify 'can expand an elective' do
    elective_as_admin
    # This is elective with ID = 2
    create_new_elective
    click_on 'Back'
    
    expect(page).to have_current_path('/electives')

    click_on 'Show'

    expect(page).to have_content("Elective details")
    expect(page).to have_link('Edit')
    expect(page).to have_link('Back')
    expect(page).to have_current_path('/electives/2')
  end

  specify 'can edit a newly created elective' do
    elective_as_admin
    # This is elective with ID = 3
    create_new_elective
    click_on 'Back'
    click_on 'Edit'

    expect(page).to have_current_path('/electives/3/edit')

    edit_elective
    click_on 'Back'

    expect(page).to have_current_path('/electives')
    within(:css, "table") { expect(page).to have_content '1234' }
  end

  specify 'can delete newly created elective' do
    elective_as_admin
    # This is elective with ID = 4
    create_new_elective
    click_on 'Back'
    click_on 'Destroy'

    expect(page).to have_content("Elective was successfully destroyed.")
    expect(page).to have_current_path('/electives')
  end

  specify 'can view the questions on an elective' do
    elective_as_admin
    # This is elective with ID = 5
    create_new_elective
    click_link 'View Questions'

    expect(page).to have_current_path('/electives/5/questions')
    expect(page).to have_link('Ask a new question')
  end
end