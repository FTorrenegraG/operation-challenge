# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(UserAccount, type: :model) do
  describe 'validations' do
    context '#out_date_after_in_date' do
      it 'should return invalid' do
        user_account = build(:user_account, out_date: Time.now - 3.days)
        expect(user_account).to_not(be_valid)
      end

      it 'should return valid' do
        user_account = build(:user_account, out_date: Time.now + 3.days)
        expect(user_account).to(be_valid)
      end
    end

    context '#last_movement_duplicated?' do
      let!(:user_account) { create(:user_account) }
      it 'should return invalid' do
        new_user_account = build(:user_account, user: user_account.user, account: user_account.account)
        expect(new_user_account).to_not(be_valid)
      end

      it 'should return valid' do
        new_user_account = build(:user_account, user: user_account.user)
        expect(new_user_account).to(be_valid)
      end
    end
  end

  describe 'delegate' do
    let!(:user_account) { create(:user_account) }
    context 'user delegate' do
      it '#user_name should return correct value' do
        expect(user_account.user_name).to(eq(user_account.user.name))
      end

      it '#user_email should return correct value' do
        expect(user_account.user_email).to(eq(user_account.user.email))
      end
    end

    context 'account delegate' do
      it '#accout_name should return correct value' do
        expect(user_account.account_name).to(eq(user_account.account.name))
      end

      it '#accout_client_name should return correct value' do
        expect(user_account.account_client_name).to(eq(user_account.account.client_name))
      end
    end
  end

  describe 'scopes' do
    let!(:user_accounts) { create_list(:user_account, 10) }
    let!(:inactive_user_accounts) do
      user_accounts.sample(2).each(&:inactive!)
    end
    context '#active' do
      it 'should not return inactive_user_accounts' do
        expect(UserAccount.active).to_not(include(inactive_user_accounts))
      end
    end

    context '#ordered' do
      it 'should return in specific order' do
        ordered_user_accounts = UserAccount.ordered.pluck(:id)
        expected_order_user_accounts = UserAccount.order(out_date: :desc, in_date: :desc).pluck(:id)
        expect(ordered_user_accounts).to(eq(expected_order_user_accounts))
      end
    end
  end

  describe 'public methods' do
    context '#inactive!' do
      let!(:user_account) { create(:user_account) }
      it 'should set out_date' do
        user_account.inactive!
        expect(user_account.reload.out_date).not_to(be_nil)
        expect(user_account.reload.out_date).to(be < Time.now)
      end
    end

    context '#active' do
      it 'should return true' do
        user_account = create(:user_account)
        expect(user_account.active).to(be_truthy)
      end

      it 'should return false' do
        user_account = create(:user_account, in_date: Time.now - 2.days, out_date: Time.now - 1.day)
        expect(user_account.active).to(be_falsey)
      end
    end
  end

  describe 'before_create callback' do
    context 'end_last_movement' do
      let!(:user_account) { create(:user_account) }
      it 'should end the last movement' do
        create(:user_account, user: user_account.user)
        expect(user_account.reload.out_date).not_to(be_nil)
      end
    end
  end
end
