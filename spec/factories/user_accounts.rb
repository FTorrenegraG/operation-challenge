# frozen_string_literal: true

FactoryBot.define do
  factory :user_account do
    user
    account
    in_date { Time.now.to_datetime }
    out_date { nil }
  end
end
