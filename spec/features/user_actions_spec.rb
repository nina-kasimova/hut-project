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

  # specify 'User can cancel account' do
  #   # Currently won't work (see method 'delete_account' in spec_helper.rb for details)
  #   delete_account

  #   expect(page).to have_current_path('/')
  #   expect(page).to have_content('Bye! Your account has been successfully cancelled. We hope to see you again soon.')
  # end
end

RSpec.describe 'Interacting with electives as a user', type: :feature do
  let!(:user) { FactoryBot.create(:user, password: "password123") }
  let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "password123", admin: true) }
  let!(:ability) { Ability.new(user) }

  specify 'can expand an elective' do
    # This is the elective with ID = 6 due to admin_spec running first
    # And temporary electives are still in existence
    signin_user_with_elective
    
    expect(page).to have_current_path('/')

    click_on 'Elective'
    click_on 'Show'

    expect(page).to have_content("Elective details")
    expect(page).to have_link('Back')
    expect(page).to have_current_path('/electives/6')
  end

  specify 'cannot create any new electives' do
    sign_in_user
    visit '/electives/new'

    expect(page).to have_content("You are not authorized to access this page.")
    expect(page).to have_current_path("/")
  end

  specify 'cannot edit any existing electives' do
    visit_admin_tool
    # This is elective with ID = 7
    create_new_elective
    logout_user
    sign_in_user
    visit '/electives/7/edit'
    
    expect(page).to have_content("You are not authorized to access this page.")
    expect(page).to have_current_path("/")
  end
end

RSpec.describe 'Searching and filtering electives as a user', type: :feature do
  let!(:user) { FactoryBot.create(:user, password: "password123") }
  let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "password123", admin: true) }

  specify 'can search and filter electives by titles' do
    # This is the elective with ID = 8
    signin_user_with_elective
    visit '/search'
    select "Test Elective", :from => "search_Title"
    click_on 'Search for Electives'

    expect(page).to have_content("Found Electives")
    expect(page).to have_content("Test Elective")
    expect(page).to have_content("Lorem")
  end
end

RSpec.describe 'Utilising the Questions and Answers on an elective as a user', type: :feature do
  let!(:user) { FactoryBot.create(:user, password: "password123") }
  let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "password123", admin: true) }

  specify 'can view questions on an elective' do
    visit_admin_tool
    # This is the elective with ID = 9
    create_new_elective
    logout_user
    sign_in_user
    visit '/electives/9'

    expect(page).to have_link('View Questions')

    click_on 'View Questions'

    expect(page).to have_link('Ask a new question')
    expect(page).to have_current_path('/electives/9/questions')
  end

  specify 'can ask a questions on an elective' do
    visit_admin_tool
    # This is the elective with ID = 10
    create_new_elective
    logout_user
    sign_in_user
    visit '/electives/10'

    expect(page).to have_link('View Questions')

    click_on 'View Questions'

    expect(page).to have_link('Ask a new question')
    expect(page).to have_current_path('/electives/10/questions')

    click_link 'Ask a new question'

    expect(page).to have_current_path('/electives/10/questions/new')

    # This is the question with ID = 1
    submit_question

    expect(page).to have_current_path('/questions/1')
    expect(page).to have_content('Test Title')
    expect(page).to have_content('Test Body')
  end

  specify 'can go to ask a question but decide not to' do
    visit_admin_tool
    # This is the elective with ID = 11
    create_new_elective
    logout_user
    sign_in_user
    visit '/electives/11'

    expect(page).to have_link('View Questions')

    click_on 'View Questions'

    expect(page).to have_link('Ask a new question')
    expect(page).to have_current_path('/electives/11/questions')

    click_link 'Ask a new question'

    expect(page).to have_link('Back to questions')
    
    click_link 'Back to questions'

    expect(page).to have_current_path('/electives/11/questions')
  end

  specify 'can view a pre-existing question on an elective' do
    visit_admin_tool
    # This is the elective with ID = 12
    create_new_elective
    visit '/electives/12'
    click_link 'View Questions'
    click_link 'Ask a new question'
    # This is the question with ID = 2
    submit_question
    logout_user
    sign_in_user
    visit '/electives/12'

    expect(page).to have_link('View Questions')

    click_on 'View Questions'

    expect(page).to have_link('Test Title')

    click_link 'Test Title'

    expect(page).to have_current_path('/questions/2')
  end

  specify 'can answer a question on an elective' do
    visit_admin_tool
    # This is the elective with ID = 13
    create_new_elective
    visit '/electives/13'
    click_link 'View Questions'
    click_link 'Ask a new question'
    # This is the question with ID = 3
    submit_question
    logout_user
    sign_in_user
    visit '/electives/13'

    expect(page).to have_link('View Questions')

    click_on 'View Questions'

    expect(page).to have_link('Test Title')

    click_link 'Test Title'

    expect(page).to have_current_path('/questions/3')
    
    fill_in 'answer_body', with: 'Answer Body'
    click_button 'Submit Answer'

    expect(page).to have_current_path('/questions/3')
    expect(page).to have_content('Answer Body')
    expect(page).to have_content('Answer was successfully created.')
  end
end