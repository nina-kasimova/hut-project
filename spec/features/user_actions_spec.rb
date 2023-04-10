require 'rails_helper'
require_relative '../spec_helper.rb'

RSpec.describe 'Logging in, logging out and changing account as a user', type: :feature do
  # Creates a temporary user with email 'test@sheffield.ac.uk' and password as below
  # from the factory bot file
  let!(:user) { FactoryBot.create(:user, password: "password123") }
  let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "password123", admin: true) }

  specify 'can change account information' do
    sign_in_user
    visit '/users/edit'

    expect(page).to have_current_path('/users/edit')
    expect(page).to have_content('Cancel my account')

    fill_in "user_email", with: "new@sheffield.ac.uk"
    fill_in 'user_current_password', with: "password123"
    click_button 'Update'

    expect(page).to have_current_path("/")
    expect(page).to have_content("Your account has been updated successfully.")
  end
end

RSpec.describe 'Interacting with electives as a user', type: :feature do
  let!(:user) { FactoryBot.create(:user, password: "password123") }
  let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "password123", admin: true) }
  let!(:ability) { Ability.new(user) }

  specify 'can expand an elective' do
    # This is the elective with ID = 9 due to admin_spec running first
    # And temporary electives are still in existence
    signin_user_with_elective
    
    expect(page).to have_current_path('/')

    click_on 'Elective'
    click_on 'Show'

    expect(page).to have_content("Elective details")
    expect(page).to have_link('Back')
    expect(page).to have_current_path('/electives/9')
  end

  specify 'cannot create any new electives' do
    sign_in_user
    visit '/electives/new'

    expect(page).to have_content("You are not authorized to access this page.")
    expect(page).to have_current_path("/")
  end

  specify 'cannot edit any existing electives' do
    elective_as_admin
    # This is elective with ID = 10
    create_new_elective
    logout_user
    sign_in_user
    visit '/electives/10/edit'
    
    expect(page).to have_content("You are not authorized to access this page.")
    expect(page).to have_current_path("/")
  end
end

# Search feature is not currently being tested due to it being written still

# RSpec.describe 'Searching and filtering electives as a user', type: :feature do
#   let!(:user) { FactoryBot.create(:user, password: "password123") }
#   let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "password123", admin: true) }

#   specify 'can search and filter electives by titles' do
#     # This is the elective with ID = 8
#     signin_user_with_elective
#     visit '/search'
#     select "Test Elective", :from => "search_Title"
#     click_on 'Search for Electives'

#     expect(page).to have_content("Found Electives")
#     expect(page).to have_content("Test Elective")
#     expect(page).to have_content("Lorem")
#   end
# end

RSpec.describe 'Utilising the Questions and Answers on an elective as a user', type: :feature do
  let!(:user) { FactoryBot.create(:user, password: "password123") }
  let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "password123", admin: true) }

  specify 'can view questions on an elective' do
    elective_as_admin
    # This is the elective with ID = 11
    create_new_elective
    logout_user
    sign_in_user
    visit '/electives/11'

    expect(page).to have_link('View Questions')

    click_on 'View Questions'

    expect(page).to have_link('Ask a new question')
    expect(page).to have_current_path('/electives/11/questions')
  end

  specify 'can ask a questions on an elective' do
    elective_as_admin
    # This is the elective with ID = 12
    create_new_elective
    logout_user
    sign_in_user
    visit '/electives/12'

    expect(page).to have_link('View Questions')

    click_on 'View Questions'

    expect(page).to have_link('Ask a new question')
    expect(page).to have_current_path('/electives/12/questions')

    click_link 'Ask a new question'

    expect(page).to have_current_path('/electives/12/questions/new')

    # This is the question with ID = 4
    submit_question
    approve_question
    sign_in_user
    visit '/electives/12/questions'

    expect(page).to have_link('Test Title')
  end

  specify 'can go to ask a question but decide not to' do
    elective_as_admin
    # This is the elective with ID = 13
    create_new_elective
    logout_user
    sign_in_user
    visit '/electives/13'

    expect(page).to have_link('View Questions')

    click_on 'View Questions'

    expect(page).to have_link('Ask a new question')
    expect(page).to have_current_path('/electives/13/questions')

    click_link 'Ask a new question'

    expect(page).to have_link('Back to questions')
    
    click_link 'Back to questions'

    expect(page).to have_current_path('/electives/13/questions')
  end

  specify 'can view a pre-existing question on an elective' do
    elective_as_admin
    # This is the elective with ID = 14
    create_new_elective
    visit '/electives/14'
    click_link 'View Questions'
    click_link 'Ask a new question'
    # This is the question with ID = 5
    submit_question
    approve_question
    sign_in_user
    visit '/electives/14'

    expect(page).to have_link('View Questions')

    click_on 'View Questions'

    expect(page).to have_link('Test Title')

    click_link 'Test Title'

    expect(page).to have_current_path('/questions/5')
  end

  specify 'can answer a question on an elective' do
    elective_as_admin
    # This is the elective with ID = 15
    create_new_elective
    visit '/electives/15'
    click_link 'View Questions'
    click_link 'Ask a new question'
    # This is the question with ID = 6
    submit_question
    approve_question
    sign_in_user
    visit '/electives/15'

    expect(page).to have_link('View Questions')

    click_on 'View Questions'

    expect(page).to have_link('Test Title')

    click_link 'Test Title'

    expect(page).to have_current_path('/questions/6')
    
    fill_in 'answer_body', with: 'Answer Body'
    click_button 'Submit Answer'

    expect(page).to have_current_path('/questions/6')
    expect(page).to have_content('Answer was successfully created.')
  end

  specify 'can refresh question creation form' do
    elective_as_admin
    # This is the elective with ID = 16
    create_new_elective
    visit '/electives/16'
    click_link 'View Questions'
    click_link 'Ask a new question'
    # This is the question with ID = 7
    submit_question
    approve_question
    sign_in_user
    visit '/electives/16'

    expect(page).to have_link('View Questions')

    click_on 'View Questions'

    expect(page).to have_link('Test Title')

    click_link 'Test Title'

    expect(page).to have_current_path('/questions/7')

    fill_in 'answer_body', with: 'Answer Body'
    click_button 'Submit Answer'
    reload_page

    expect(page).to have_current_path('/questions/7')
  end
end