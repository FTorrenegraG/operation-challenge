# frozen_string_literal: true

class UserAccount < ApplicationRecord
  belongs_to :user
  belongs_to :account

  validate :out_date_after_in_date
  validate :last_movement_duplicated?, on: :create

  delegate :name, :client_name, to: :account, prefix: true
  delegate :name, :email, to: :user, prefix: true

  before_create :end_last_movement

  scope :active, -> { where(out_date: nil).or(where('out_date > ?', Time.now.to_datetime)) }
  scope :ordered, -> { order(out_date: :desc, in_date: :desc) }

  def inactive!
    self.out_date = Time.now.to_datetime

    save
  end

  def active
    out_date.nil? || out_date > Time.now.to_datetime
  end

  private

  def out_date_after_in_date
    return if out_date.blank? || in_date.blank?
    return true if in_date < out_date

    errors.add(:out_date, 'must be after the in date')
  end

  def last_movement_duplicated?
    last_movement = UserAccount.where(user_id:, account_id:).active.last
    return true unless last_movement

    errors.add(:account_id, 'Your last movement active is in the same account')
  end

  def end_last_movement
    last_movement = UserAccount.where(user_id:).active.last
    return true unless last_movement

    last_movement.inactive!
  end
end
