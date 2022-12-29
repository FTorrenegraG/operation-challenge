# frozen_string_literal: true

FactoryBot.define do
  factory :user_account do
    user { nil }
    account { nil }
    in_date { '2022-12-29 16:42:55' }
    out_date { '2022-12-29 16:42:55' }
  end
end
