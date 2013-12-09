FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :work do
    title "New Work"
    payment 100.0
    other "Lerem ipsum"
    orderer_id 0
    user
  end

  factory :orderer do
    name "New Orderer"
    user
  end

  factory :worktime do
    start_time Time.now
    work
  end
end
