require 'rails_helper'
require_relative '../spec_helper.rb'

describe 'Interacting with site as user' do
  # Creates a temporary user with email 'my.email@sheffield.ac.uk' and password as below
  # from the factory bot file
  let!(:user) { FactoryBot.create(:user, password: "password123") }

  # Very standard login feature test. This will be expanded later
  specify 'I can login as a user' do
    sign_in_user

    expect(page).to have_content 'my.email@sheffield.ac.uk'
    expect(page).to have_content 'Logout'

    click_on 'Logout'

    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Login'
  end
end