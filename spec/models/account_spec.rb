# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Account, type: :model) do
  describe 'validations' do
    context 'name validation' do
      let!(:account) { create(:account) }
      let!(:new_account) { build(:account, name: account.name) }
      it 'should be invalid' do
        expect(new_account).to_not(be_valid)
      end

      it 'should include error message in name' do
        new_account.valid?
        expect(new_account.errors[:name].first).to(eq('has already been taken'))
      end
    end
  end
end
