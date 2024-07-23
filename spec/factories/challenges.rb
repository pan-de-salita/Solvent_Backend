FactoryBot.define do
  factory :challenge do
    trait :with_title do
      title { 'Test Challenge' }
    end

    trait :with_description do
      description { 'Description for Test Challenge' }
    end

    trait :with_start_date do
      start_date { Date.today }
    end

    trait :with_end_date do
      end_date { Date.today + 10 }
    end
  end
end
