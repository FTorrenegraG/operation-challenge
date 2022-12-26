# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :user do
    email { Faker::Internet.safe_email }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
