require 'rails_helper'
require_relative '../spec_helper.rb'

describe 'Interacting with site as an admin' do
  # Creates a temporary user with email 'my.email@sheffield.ac.uk' and password as below
  # from the factory bot file
  let!(:user) { FactoryBot.create(:user, password: "password123") }
  let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "password123", admin: true) }

  specify 'Admin can login as an admin' do
    sign_in_admin

    expect(page).to have_current_path("/")
    expect(page).to have_content("admin@sheffield.ac.uk")

    logout_user

    expect(page).to have_current_path("/")
  end
  
  specify 'Admin can visit the admin tool page' do
    visit_admin_tool

    expect(page).to have_current_path('/electives')
    expect(page).to have_content("Listing Electives")
    expect(page).to have_link("New Elective")
  end

  specify 'Admin can create new elective via admin tool page' do
    visit_admin_tool

    expect(page).to have_link("New Elective")

    create_new_elective

    expect(page).to have_content("Elective was successfully created.")
    expect(page).to have_content("Test Elective")
    expect(page)
    expect(page).to have_current_path("/electives/1")

    click_on 'Back'

    expect(page).to have_current_path("/electives")
    within(:css, "table") { expect(page).to have_content 'Test Elective' }
    within(:css, "table") { expect(page).to have_content 'Lorem ipsum delorum' }
  end

  specify 'Admin can edit a newly created elective' do
    visit_admin_tool
    create_new_elective
    click_on 'Back'
    click_on 'Edit'
    edit_elective
    click_on 'Back'

    expect(page).to have_current_path('/electives')
    within(:css, "table") { expect(page).to have_content '1234' }
  end
end