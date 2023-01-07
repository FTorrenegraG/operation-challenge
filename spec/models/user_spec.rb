# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(User, type: :model) do
  describe 'before_create methods' do
    it 'should save jti in user when is created' do
      user = User.create(email: 'foo@example.com', password: '123456')
      expect(user.jti).not_to(be_empty)
    end
  end

  describe '#jwt_payload' do
    it 'should include access_level' do
      expect(User.new.jwt_payload.keys).to(include(:access_level))
    end
  end

  describe 'has_many and has_one relations' do
    let!(:user) { create(:user) }
    let!(:user_account_false) { create(:user_account, user:, in_date: Time.now - 2.day, out_date: Time.now - 1.day) }
    let!(:user_account_active) { create(:user_account, user:) }

    context '#user_accounts' do
      it 'should return all user accounts including active false' do
        expect(user.user_accounts.count).to(eq(2))
        expect(user.user_accounts).to(include(user_account_false))
      end
    end

    context '#user_account' do
      it 'should return only the active user_account' do
        expect(user.user_account).to(eq(user_account_active))
      end
    end

    context '#account' do
      it 'should return only the active account' do
        expect(user.account).to(eq(user_account_active.account))
      end
    end
  end
end
