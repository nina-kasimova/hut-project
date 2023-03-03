# == Schema Information
#
# Table name: electives
#
#  id           :bigint           not null, primary key
#  Accomodation :boolean
#  Description  :text
#  Location     :string
#  Speciality   :string
#  Title        :string
#  Type         :string
#  WP_Support   :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :elective do
    Title { "MyString" }
    Description { "MyText" }
    Speciality { "MyString" }
    Location { "MyString" }
    Accomodation { false }
    WP_Support { false }
    Type { "MyString" }
  end
end
