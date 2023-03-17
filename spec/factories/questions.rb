# == Schema Information
#
# Table name: questions
#
#  id          :bigint           not null, primary key
#  body        :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  elective_id :bigint           not null
#
# Indexes
#
#  index_questions_on_elective_id  (elective_id)
#
# Foreign Keys
#
#  fk_rails_...  (elective_id => electives.id)
#
FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
  end
end
