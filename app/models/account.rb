# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :user_accounts, dependent: :restrict_with_error
  has_many :users, through: :user_accounts
end
