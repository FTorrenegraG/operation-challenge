FactoryBot.define do
  factory :user do
    email { 'foo@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end