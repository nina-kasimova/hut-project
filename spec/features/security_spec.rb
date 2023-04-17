require 'rails_helper'
require_relative '../spec_helper.rb'

RSpec.describe 'User Authentication', type: :feature do

	let!(:user) { FactoryBot.create(:user, password: "password123") }
  	let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "password123", admin: true) }

  	before :each do
    	nil
  	end

  	specify 'As a guest, I cannot access electives page without logging in' do
	  	visit '/'
	  	visit 'electives'

	  	expect(page).to have_content("You need to sign in or sign up before continuing.")
	    expect(page).to have_current_path('/users/sign_in')

	    sign_in_user
	    visit '/electives'

	    expect(page).to have_current_path('/electives')
	end
end