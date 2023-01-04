# frozen_string_literal: true

class UserAccount < ApplicationRecord
  belongs_to :user
  belongs_to :account

  validate :last_movement_duplicated?, on: :create

  before_create :end_last_movement

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(out_date: :desc, in_date: :desc) }
  default_scope { active }

  def inactive!
    self.out_date = Time.now.to_datetime
    self.active = false

    save
  end

  private

  def last_movement_duplicated?
    last_movement = UserAccount.where(user_id:, account_id:).last
    return true unless last_movement

    errors.add(:account_id, 'Your last movement active is in the same account')
    false
  end

  def end_last_movement
    last_movement = UserAccount.where(user_id:).last
    return true unless last_movement

    last_movement.inactive!
  end
end
