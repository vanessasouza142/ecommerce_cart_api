FactoryBot.define do
  factory :cart do
    abandoned { false }

    trait :inactive do
      updated_at { 4.hours.ago }
    end

    trait :active do
      updated_at { 1.hour.ago }
    end

    trait :old_abandoned_cart do
      abandoned { true }
      abandoned_at { 8.days.ago }
    end

    trait :recent_abandoned_cart do
      abandoned { true }
      abandoned_at { 6.days.ago }
    end
  end
end