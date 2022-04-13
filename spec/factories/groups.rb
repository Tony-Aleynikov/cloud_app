FactoryBot.define do
  factory :group do
    # name { "MyString" }
    sequence(:name) { |n| "group_#{n}" }
  end
end
