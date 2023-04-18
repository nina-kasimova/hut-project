require 'rails_helper'
require_relative '../spec_helper.rb'

RSpec.describe 'User Authentication', type: :feature do

	let!(:user) { FactoryBot.create(:user, password: "password123") }
  	let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "password123", admin: true) }

  	before :each do
    	nil
  	end

  	specify 'As a guest, I cannot access search page without logging in' do
	  	visit '/'
	  	visit 'search'

	  	expect(page).to have_content("You need to sign in or sign up before continuing.")
	    expect(page).to have_current_path('/users/sign_in')

	    sign_in_user
	    visit '/search'

	    expect(page).to have_current_path('/search')
	end
end

RSpec.describe 'Vunerabilities', type: :feature do

	let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "password123", admin: true) }

	before :each do
    	nil
  	end

  	specify "As an admin, I cannot perform an SQL injection attack" do
  		login_as :admin

  		visit 'search'
	    click_on 'New Elective'
	    fill_in 'elective_Title', with: "SQL_INJECTION"
	    fill_in 'elective_Description', with: "sql') OR '1'--"
	    fill_in 'elective_Speciality', with: "sql') OR '1'--"
	    check 'elective_Accomodation'
	    check 'elective_WP_Support'
	    fill_in 'elective_Type', with: "///"
	    click_on 'Save'
  	
	  	visit 'search'
	  	click_on 'SEARCH FOR ELECTIVES'
	  	expect(page).not_to have_content("SQL_INJECTION")
	end
end




