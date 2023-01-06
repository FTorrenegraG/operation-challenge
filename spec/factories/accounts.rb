# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :account do
    name { Faker::Company.name }
    client_name { Faker::Company.name }
    manager_name { Faker::Name.name }
  end
end
