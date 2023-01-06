# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :user_accounts, dependent: :restrict_with_error

  has_one :user_account, -> { active }
  has_one :account, through: :user_account

  before_create :jti_token

  enum access_level: {
    standart: 0,
    admin: 1,
    super_admin: 2
  }

  def jwt_payload
    super.merge({ access_level: })
  end

  def current_account
    user_accounts.active.ordered.first&.account
  end

  private

  def jti_token
    SecureRandom.uuid
  end
end
